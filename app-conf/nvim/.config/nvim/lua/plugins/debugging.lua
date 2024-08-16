return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "leoluz/nvim-dap-go",
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")

    require("dapui").setup()
    require("dap-go").setup()

    local debug_win = nil
    local debug_tab = nil
    local debug_tabnr = nil

    local function open_in_tab()
      if debug_win and vim.api.nvim_win_is_valid(debug_win) then
        vim.api.nvim_set_current_win(debug_win)
        return
      end

      vim.cmd("tabedit %")
      debug_win = vim.fn.win_getid()
      debug_tab = vim.api.nvim_win_get_tabpage(debug_win)
      debug_tabnr = vim.api.nvim_tabpage_get_number(debug_tab)

      dapui.open()
    end

    local function close_tab()
      dapui.close()

      if debug_tab and vim.api.nvim_tabpage_is_valid(debug_tab) then
        vim.api.nvim_exec("tabclose " .. debug_tabnr, false)
      end

      debug_win = nil
      debug_tab = nil
      debug_tabnr = nil
    end

    dap.listeners.before.attach.dapui_config = function()
      open_in_tab()
    end
    dap.listeners.before.launch.dapui_config = function()
      open_in_tab()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      close_tab()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      close_tab()
    end

    vim.keymap.set("n", "<F5>", function()
      dap.continue()
    end)
    vim.keymap.set("n", "<F6>", function()
      dap.step_over()
    end)
    vim.keymap.set("n", "<F7>", function()
      dap.step_into()
    end)
    vim.keymap.set("n", "<F8>", function()
      dap.step_out()
    end)
    vim.keymap.set("n", "<Leader>b", function()
      dap.toggle_breakpoint()
    end)
    vim.keymap.set("n", "<Leader>B", function()
      dap.set_breakpoint()
    end)
    vim.keymap.set("n", "<Leader>lp", function()
      dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end)
  end,
}
