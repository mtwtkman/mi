require("avante").setup({
  provider = "gemini",
  providers = {
    gemini = {
      endpiont = "https://generativelanguage.googleapis.com/v1beta/models",
      model = "gemini-2.0-flash",
      timeout = 30000,
      extra_request_body = {
        temperature = 0.75,
        max_tokens = 200,
      },
    }
  }
})
