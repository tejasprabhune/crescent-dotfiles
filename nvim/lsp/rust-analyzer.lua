return {
    cmd = { "rust-analyzer" },
    -- see https://rust-analyzer.github.io/book/configuration.html
    root_markers = { "Cargo.toml", ".git" },
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = true,
            check = { command = "clippy" },
            cargo = {
                allFeatures = true,
                buildScripts = false,
            },
            files = {
                excludeDirs = {'./target'},
            },
            imports = { group = { enable = false } },
            completion = {
                postfix = { enable = false },
                fullFunctionSignatures = { enable = true },
            },
            -- diagnostics = { enable = true },
            rustfmt = { enable = true },
            semanticHighlighting = {
                -- do not highlight rust code in docstrings
                doc = { comment = { inject = { enable = false } } }
            }

        },

    },
    filetypes = { "rust" }
}
