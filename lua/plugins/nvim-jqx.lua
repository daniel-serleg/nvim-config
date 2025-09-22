return {
  "gennaro-tedesco/nvim-jqx",
  event = {"BufReadPost"},
  ft = { "json", "yaml" },
}

-- | Command    | description |
-- | -------- | -------     |
-- | JqxList  | populate the quickfix window with json keys    |
-- | JqxList string | populate the quickfix window with string values     |
-- | JqxQuery   | executes a generic jq query in the current file  |
-- | <CR> | go to key location in file |
-- | X | query values of key under cursor |
-- | <Esc> | close floating window |
