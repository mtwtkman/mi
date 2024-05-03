return {
  adapter = {
    type = "executable",
    command = "haskell-debug-adapter",
    args = {},
  },
  client = {
    {
      type = "haskell",
      request = "launch",
      name = "Debug",
      workspace = "${workspaceFolder}",
      startup = "${file}",
      stopOnEntry = true,
      logFile = vim.fn.stdpath("data") .. "/haskell-dap.log",
      logLevel = "DEBUG",
      ghciEnv = vim.empty_dict(),
      ghciPrompt = "λ: ",
      ghciInitialPrompt = "ghci> ",
      ghciCmd= "cabal exec -- ghci-dap --interactive -i ${workspaceFolder}",
    },
  },
}
