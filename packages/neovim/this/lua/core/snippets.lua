return {
  ruby = {
    fsl = "# frozen_string_literal: true\n$0",
    rubo = "# rubocop:disable $0",
    dbg = "require 'debug';binding.break\n$0",
    deb = "require 'debug';binding.break\n$0",
  },
  python = {
    pdb = "import pdb;pdb.set_trace();\n$0",
  },
}
