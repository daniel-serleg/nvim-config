local function get_jdtls()
    -- Use Mason's standard installation path
    local mason_packages_path = vim.fn.stdpath("data") .. "/mason/packages"
    local jdtls_path = mason_packages_path .. "/jdtls"
    
    -- Check if JDTLS is installed by checking if the directory exists
    if vim.fn.isdirectory(jdtls_path) == 0 then
        vim.notify("JDTLS is not installed at " .. jdtls_path .. ". Please install it with :MasonInstall jdtls", vim.log.levels.ERROR)
        return nil, nil, nil
    end
    
    -- Obtain the path to the jar which runs the language server
    local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
    
    -- Declare which operating system we are using, windows use win, macos use mac
    local SYSTEM = "linux"
    if vim.fn.has("win32") == 1 then
        SYSTEM = "win"
    elseif vim.fn.has("unix") == 1 then
        if vim.fn.has("mac") == 1 then
            -- Check if it's Apple Silicon or Intel Mac
            local arch = vim.fn.system("uname -m"):gsub("%s+", "")
            if arch == "arm64" then
                SYSTEM = "mac_arm"
            else
                SYSTEM = "mac"
            end
        else
            -- Check if it's ARM Linux
            local arch = vim.fn.system("uname -m"):gsub("%s+", "")
            if arch == "aarch64" or arch == "arm64" then
                SYSTEM = "linux_arm"
            else
                SYSTEM = "linux"
            end
        end
    end
    
    -- Obtain the path to configuration files for your specific operating system
    local config = jdtls_path .. "/config_" .. SYSTEM
    -- Obtain the path to the Lombok jar
    local lombok = jdtls_path .. "/lombok.jar"
    return launcher, config, lombok
end

local function get_bundles()
    local bundles = {}
    local mason_packages_path = vim.fn.stdpath("data") .. "/mason/packages"
    
    -- Check if java-debug-adapter is installed
    local java_debug_path = mason_packages_path .. "/java-debug-adapter"
    if vim.fn.isdirectory(java_debug_path) == 1 then
        -- Add the debug adapter jar to bundles
        local debug_jar = vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1)
        if debug_jar ~= "" then
            table.insert(bundles, debug_jar)
        end
    else
        vim.notify("java-debug-adapter not installed. Debug functionality may not work.", vim.log.levels.WARN)
    end

    -- Check if java-test is installed
    local java_test_path = mason_packages_path .. "/java-test"
    if vim.fn.isdirectory(java_test_path) == 1 then
        -- Add all of the Jars for running tests in debug mode to the bundles list
        local test_jars = vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", 1), "\n")
        for _, jar in ipairs(test_jars) do
            if jar ~= "" then
                table.insert(bundles, jar)
            end
        end
    else
        vim.notify("java-test not installed. Test functionality may not work.", vim.log.levels.WARN)
    end

    return bundles
end

local function get_workspace()
    -- Get the home directory of your operating system
    local home = os.getenv("HOME")
    if not home then
        home = vim.fn.expand("~")
    end
    -- Declare a directory where you would like to store project information
    local workspace_path = home .. "/code/workspace/"
    -- Determine the project name
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    -- Create the workspace directory by concatenating the designated workspace path and the project name
    local workspace_dir = workspace_path .. project_name
    
    -- Ensure the workspace directory exists
    vim.fn.mkdir(workspace_dir, "p")
    
    return workspace_dir
end

local function java_keymaps(bufnr)
    -- Allow yourself to run JdtCompile as a Vim command
    vim.cmd("command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)")
    -- Allow yourself/register to run JdtUpdateConfig as a Vim command
    vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
    -- Allow yourself/register to run JdtBytecode as a Vim command
    vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
    -- Allow yourself/register to run JdtShell as a Vim command
    vim.cmd("command! -buffer JdtJshell lua require('jdtls').jshell()")

    -- Set a Vim motion to <Space> + <Shift>J + o to organize imports in normal mode
    vim.keymap.set('n', '<leader>Jo', "<Cmd> lua require('jdtls').organize_imports()<CR>", { buffer = bufnr, desc = "[J]ava [O]rganize Imports" })
    -- Set a Vim motion to <Space> + <Shift>J + v to extract the code under the cursor to a variable
    vim.keymap.set('n', '<leader>Jv', "<Cmd> lua require('jdtls').extract_variable()<CR>", { buffer = bufnr, desc = "[J]ava Extract [V]ariable" })
    -- Set a Vim motion to <Space> + <Shift>J + v to extract the code selected in visual mode to a variable
    vim.keymap.set('v', '<leader>Jv', "<Esc><Cmd> lua require('jdtls').extract_variable(true)<CR>", { buffer = bufnr, desc = "[J]ava Extract [V]ariable" })
    -- Set a Vim motion to <Space> + <Shift>J + <Shift>C to extract the code under the cursor to a static variable
    vim.keymap.set('n', '<leader>JC', "<Cmd> lua require('jdtls').extract_constant()<CR>", { buffer = bufnr, desc = "[J]ava Extract [C]onstant" })
    -- Set a Vim motion to <Space> + <Shift>J + <Shift>C to extract the code selected in visual mode to a static variable
    vim.keymap.set('v', '<leader>JC', "<Esc><Cmd> lua require('jdtls').extract_constant(true)<CR>", { buffer = bufnr, desc = "[J]ava Extract [C]onstant" })
    -- Set a Vim motion to <Space> + <Shift>J + t to run the test method currently under the cursor
    vim.keymap.set('n', '<leader>Jt', "<Cmd> lua require('jdtls').test_nearest_method()<CR>", { buffer = bufnr, desc = "[J]ava [T]est Method" })
    -- Set a Vim motion to <Space> + <Shift>J + t to run the test method that is currently selected in visual mode
    vim.keymap.set('v', '<leader>Jt', "<Esc><Cmd> lua require('jdtls').test_nearest_method(true)<CR>", { buffer = bufnr, desc = "[J]ava [T]est Method" })
    -- Set a Vim motion to <Space> + <Shift>J + <Shift>T to run an entire test suite (class)
    vim.keymap.set('n', '<leader>JT', "<Cmd> lua require('jdtls').test_class()<CR>", { buffer = bufnr, desc = "[J]ava [T]est Class" })
    -- Set a Vim motion to <Space> + <Shift>J + u to update the project configuration
    vim.keymap.set('n', '<leader>Ju', "<Cmd> JdtUpdateConfig<CR>", { buffer = bufnr, desc = "[J]ava [U]pdate Config" })
end

local function setup_jdtls()
    -- Get access to the jdtls plugin and all of its functionality
    local jdtls = require "jdtls"

    -- Get the paths to the jdtls jar, operating specific configuration directory, and lombok jar
    local launcher, os_config, lombok = get_jdtls()
    
    -- Check if JDTLS setup was successful
    if not launcher or launcher == "" then
        vim.notify("Failed to setup JDTLS. Please check your installation.", vim.log.levels.ERROR)
        return
    end

    -- Get the path you specified to hold project information
    local workspace_dir = get_workspace()

    -- Get the bundles list with the jars to the debug adapter, and testing adapters
    local bundles = get_bundles()

    -- Determine the root directory of the project by looking for these specific markers
    -- Enhanced root detection for Maven multi-module projects
    local root_dir = jdtls.setup.find_root({ 
        '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle',
        '.project', '.settings', 'src/main/java'
    });
    
    -- If we're in a submodule, try to find the parent project root
    if root_dir and vim.fn.filereadable(root_dir .. '/pom.xml') == 1 then
        local parent_dir = vim.fn.fnamemodify(root_dir, ':h')
        while parent_dir ~= '/' and parent_dir ~= root_dir do
            if vim.fn.filereadable(parent_dir .. '/pom.xml') == 1 then
                -- Check if this is a parent pom with modules
                local parent_pom = vim.fn.readfile(parent_dir .. '/pom.xml')
                for _, line in ipairs(parent_pom) do
                    if line:match('<modules>') then
                        root_dir = parent_dir
                        break
                    end
                end
            end
            parent_dir = vim.fn.fnamemodify(parent_dir, ':h')
        end
    end
    
    -- Tell our JDTLS language features it is capable of
    local capabilities = {
        workspace = {
            configuration = true,
            didChangeWatchedFiles = {
                dynamicRegistration = true
            }
        },
        textDocument = {
            completion = {
                snippetSupport = false,
                completionItem = {
                    documentationFormat = { "markdown", "plaintext" }
                }
            }
        }
    }

    local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

    for k,v in pairs(lsp_capabilities) do capabilities[k] = v end

    -- Get the default extended client capablities of the JDTLS language server
    local extendedClientCapabilities = jdtls.extendedClientCapabilities
    -- Modify one property called resolveAdditionalTextEditsSupport and set it to true
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    -- Set the command that starts the JDTLS language server jar
    local cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-javaagent:' .. lombok,
        '-jar',
        launcher,
        '-configuration',
        os_config,
        '-data',
        workspace_dir,
    }

     -- Configure settings in the JDTLS server
    local settings = {
        java = {
            -- Enable code formatting
            format = {
                enabled = true,
                -- Use the Google Style guide for code formattingh
                settings = {
                    url = vim.fn.stdpath("config") .. "/lang_servers/intellij-java-google-style.xml",
                    profile = "GoogleStyle"
                }
            },
            -- Enable downloading archives from eclipse automatically
            eclipse = {
                downloadSource = true
            },
            -- Enable downloading archives from maven automatically
            maven = {
                downloadSources = true,
                updateSnapshots = true
            },
            -- Enable method signature help
            signatureHelp = {
                enabled = true
            },
            -- Use the fernflower decompiler when using the javap command to decompile byte code back to java code
            contentProvider = {
                preferred = "fernflower"
            },
            -- Setup automatical package import oranization on file save
            saveActions = {
                organizeImports = true
            },
            -- Customize completion options
            completion = {
                enabled = true,
                guessMethodArguments = true,
                maxResults = 50,
                -- When using an unimported static method, how should the LSP rank possible places to import the static method from
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "org.junit.Assert.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*",
                    "org.mockito.ArgumentMatchers.*",
                    "org.mockito.BDDMockito.*",
                    "org.assertj.core.api.Assertions.*",
                    "org.springframework.test.web.servlet.MockMvcRequestBuilders.*",
                    "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
                    "org.springframework.test.web.servlet.result.MockMvcResultHandlers.*",
                },
                -- Try not to suggest imports from these packages in the code action window
                filteredTypes = {
                    "com.sun.*",
                    "io.micrometer.shaded.*",
                    "java.awt.*",
                    "jdk.*",
                    "sun.*",
                },
                -- Set the order in which the language server should organize imports
                importOrder = {
                    "java",
                    "jakarta",
                    "javax",
                    "org.springframework",
                    "org",
                    "com",
                    ""
                }
            },
            sources = {
                -- How many classes from a specific package should be imported before automatic imports combine them all into a single import
                organizeImports = {
                    starThreshold = 9999,
                    staticThreshold = 9999
                }
            },
            -- How should different pieces of code be generated?
            codeGeneration = {
                -- When generating toString use a json format
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
                },
                -- When generating hashCode and equals methods use the java 7 objects method
                hashCodeEquals = {
                    useJava7Objects = true
                },
                -- When generating code use code blocks
                useBlocks = true
            },
             -- If changes to the project will require the developer to update the projects configuration advise the developer before accepting the change
            configuration = {
                updateBuildConfiguration = "interactive"
            },
            -- enable code lens in the lsp
            referencesCodeLens = {
                enabled = true
            },
            -- enable inlay hints for parameter names,
            inlayHints = {
                parameterNames = {
                    enabled = "all"
                }
            },
            -- Enhanced settings for Spring and annotation processing
            autobuild = {
                enabled = true
            },
            -- Enable annotation processing for Spring annotations
            compile = {
                nullAnalysis = {
                    mode = "automatic"
                }
            },
            -- Better Spring Boot support
            project = {
                referencedLibraries = {
                    "lib/**/*.jar",
                    "**/target/dependency/*.jar"
                },
                sourcePaths = {
                    "src/main/java",
                    "src/test/java",
                    "target/generated-sources",
                    "target/generated-test-sources"
                }
            },
            -- Enable test scope dependencies
            test = {
                vmArgs = {},
                sourcePaths = {
                    "src/test/java",
                    "src/test/resources"
                }
            },
            -- Improved import handling for Spring
            imports = {
                gradle = {
                    enabled = true
                },
                maven = {
                    enabled = true
                },
                includeDecompiledSources = true
            },
            -- Configure runtime for test scope
            runtimes = {},
            -- Ensure all scopes are included
            dependency = {
                autoRefresh = true,
                includeProvided = true,
                includeTest = true
            },
            -- Enhanced annotation processing
            implementationsCodeLens = {
                enabled = true
            },
            -- Better support for Spring Boot configuration
            references = {
                includeDecompiledSources = true
            }
        }
    }

    -- Create a table called init_options to pass the bundles with debug and testing jar, along with the extended client capablies to the start or attach function of JDTLS
    local init_options = {
        bundles = bundles,
        extendedClientCapabilities = extendedClientCapabilities
    }

    -- Function that will be ran once the language server is attached
    local on_attach = function(_, bufnr)
        -- Map the Java specific key mappings once the server is attached
        java_keymaps(bufnr)

        -- Setup the java debug adapter of the JDTLS server
        require('jdtls.dap').setup_dap()

        -- Find the main method(s) of the application so the debug adapter can successfully start up the application
        -- Sometimes this will randomly fail if language server takes to long to startup for the project, if a ClassDefNotFoundException occurs when running
        -- the debug tool, attempt to run the debug tool while in the main class of the application, or restart the neovim instance
        -- Unfortunately I have not found an elegant way to ensure this works 100%
        require('jdtls.dap').setup_dap_main_class_configs()
        -- Enable jdtls commands to be used in Neovim
        require 'jdtls.setup'.add_commands()
        -- Refresh the codelens
        -- Code lens enables features such as code reference counts, implemenation counts, and more.
        vim.lsp.codelens.refresh()

        -- Setup a function that automatically runs every time a java file is saved to refresh the code lens
        vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.java" },
            callback = function()
                local _, _ = pcall(vim.lsp.codelens.refresh)
            end
        })
    end

    -- Create the configuration table for the start or attach function
    local config = {
        cmd = cmd,
        root_dir = root_dir,
        settings = settings,
        capabilities = capabilities,
        init_options = init_options,
        on_attach = on_attach
    }

    -- Start the JDTLS server
    require('jdtls').start_or_attach(config)
end

return {
    setup_jdtls = setup_jdtls,
}
