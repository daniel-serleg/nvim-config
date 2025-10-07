-- Utility functions for JDTLS troubleshooting

local M = {}

-- Function to clean JDTLS workspace and force rebuild
function M.clean_workspace()
    local home = os.getenv("HOME") or vim.fn.expand("~")
    local workspace_path = home .. "/code/workspace/"
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = workspace_path .. project_name
    
    vim.notify("Cleaning JDTLS workspace: " .. workspace_dir, vim.log.levels.INFO)
    
    -- Close all Java buffers
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            local bufname = vim.api.nvim_buf_get_name(buf)
            if bufname:match("%.java$") then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end
    end
    
    -- Stop LSP clients
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    
    -- Remove workspace directory
    vim.fn.system("rm -rf " .. vim.fn.shellescape(workspace_dir))
    
    vim.notify("Workspace cleaned. Please restart Neovim.", vim.log.levels.WARN)
end

-- Function to diagnose Maven dependencies
function M.check_maven_dependencies()
    local pom_path = vim.fn.getcwd() .. "/pom.xml"
    
    if vim.fn.filereadable(pom_path) == 0 then
        vim.notify("No pom.xml found in current directory", vim.log.levels.ERROR)
        return
    end
    
    vim.notify("Checking Maven dependencies...", vim.log.levels.INFO)
    
    -- Run Maven command to verify dependencies
    local cmd = "cd " .. vim.fn.getcwd() .. " && mvn dependency:resolve -DincludeScope=test"
    local result = vim.fn.system(cmd)
    
    if vim.v.shell_error == 0 then
        vim.notify("Maven dependencies resolved successfully", vim.log.levels.INFO)
    else
        vim.notify("Maven dependency resolution failed:\n" .. result, vim.log.levels.ERROR)
    end
end

-- Function to check if test dependencies are in local Maven repository
function M.check_local_maven_repo()
    local home = os.getenv("HOME") or vim.fn.expand("~")
    local m2_repo = home .. "/.m2/repository"
    
    local test_packages = {
        { name = "JUnit", path = m2_repo .. "/org/junit" },
        { name = "Mockito", path = m2_repo .. "/org/mockito" },
        { name = "Spring Test", path = m2_repo .. "/org/springframework" },
        { name = "AssertJ", path = m2_repo .. "/org/assertj" },
    }
    
    vim.notify("Checking local Maven repository...", vim.log.levels.INFO)
    
    for _, pkg in ipairs(test_packages) do
        if vim.fn.isdirectory(pkg.path) == 1 then
            vim.notify("✓ " .. pkg.name .. " found in local Maven repo", vim.log.levels.INFO)
        else
            vim.notify("✗ " .. pkg.name .. " NOT found in local Maven repo", vim.log.levels.WARN)
        end
    end
end

-- Function to force Maven update
function M.maven_force_update()
    vim.notify("Forcing Maven to update dependencies...", vim.log.levels.INFO)
    
    local cmd = "cd " .. vim.fn.getcwd() .. " && mvn clean compile test-compile -U"
    local result = vim.fn.system(cmd)
    
    if vim.v.shell_error == 0 then
        vim.notify("Maven update successful. Cleaning JDTLS workspace...", vim.log.levels.INFO)
        M.clean_workspace()
    else
        vim.notify("Maven update failed:\n" .. result, vim.log.levels.ERROR)
    end
end

-- Register commands
vim.api.nvim_create_user_command("JdtlsCleanWorkspace", M.clean_workspace, {})
vim.api.nvim_create_user_command("JdtlsCheckMaven", M.check_maven_dependencies, {})
vim.api.nvim_create_user_command("JdtlsCheckRepo", M.check_local_maven_repo, {})
vim.api.nvim_create_user_command("JdtlsForceUpdate", M.maven_force_update, {})

return M

