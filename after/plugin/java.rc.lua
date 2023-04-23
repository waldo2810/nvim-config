local jdtls_dir = vim.fn.stdpath('data') .. '/mason/packages/jdtls'
local config_dir = jdtls_dir .. '/config_win'
local plugins_dir = jdtls_dir .. '/plugins/'
local path_to_jar = plugins_dir .. 'org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar'


local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
  return
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':ph:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/site/java/workspace_root' .. project_name
os.execute("mkdir " .. workspace_dir)

-- Main config
local config = {
  cmd = {
    'C:/Program Files/Java/jdk-19/bin/java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    '-jar', path_to_jar,
    '-configuration', config_dir,
    '-data', workspace_dir,
  },
  root_dir = root_dir,
  settings = {
    java = {
      home = 'C:/Program Files/Java/jdk-19',
      eclipse = { downloadSources = true },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          {
            name = 'JavaSE-19',
            path = 'C:/Program Files/Java/jdk-19'
          },
          {
            name = 'JavaSE-17',
            path = 'C:/Program Files/Java/jdk-17'
          },
          {
            name = 'JavaSE-11',
            path = 'C:/Program Files/Java/jdk-11.0.17'
          }
        }
      },
      maven = { downloadSources = true },
      implementationsCodeLens = { enabled = true },
      references = { includeDecompiledSources = true },
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath "config" .. "/java/code-style/intellij-java-google-style.xml",
          profile = "GoogleStyle"
        },
      }
    },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
      importOrder = {
        "java",
        "javax",
        "com",
        "org"
      },
    },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      useBlocks = true,
    },
  },
  flags = {
    allow_incremental_sync = true,
  },
  init_options = {
    bundles = {},
  },
}

config['on_attach'] = function(client, bufnr)
  require 'wasb.maps'.map_java_keys(bufnr);
  require "lsp_signature".on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    floating_window_above_cur_line = false,
    padding = '',
    handler_opts = {
      border = "rounded"
    }
  }, bufnr)
end

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
