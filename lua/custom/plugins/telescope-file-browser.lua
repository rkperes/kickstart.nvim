local open_dialog = function ()
    require("telescope").extensions.file_browser.file_browser()
end

return {
    {
        "nvim-telescope/telescope-file-browser.nvim",
        lazy = false,

        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },

        config = function ()
            require("telescope").load_extension("file_browser")

            vim.keymap.set('n', '<leader>ff', open_dialog, { buffer = bufnr, desc = 'Open file browser' })
        end,
    }
}
