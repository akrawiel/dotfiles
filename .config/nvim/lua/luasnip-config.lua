local luasnip = require("luasnip")

local s = luasnip.snippet
local i = luasnip.insert_node

local fmt = require("luasnip.extras.fmt").fmt

local js_snippets = {
	s(
		"arrow function",
		fmt(
			[[
      ({}) => {{
        {}
      }}
      ]],
			{ i(1), i(2) }
		)
	),
	s(
		"named function",
		fmt(
			[[
      funtion {}({}) {{
        {}
      }}
      ]],
			{ i(1), i(2), i(3) }
		)
	),
	s("clog", fmt("console.log({})", { i(1) })),
	s("cinfo", fmt("console.info({})", { i(1) })),
  s("if", fmt(
    [[
    if ({}) {{
      {}
    }}
    ]],
    { i(1), i(2) }
  )),
  s("else", fmt(
    [[
    else {{
      {}
    }}
    ]],
    { i(1) }
  )),
  s("elseif", fmt(
    [[
    else if ({}) {{
      {}
    }}
    ]],
    { i(1), i(2) }
  )),
}

luasnip.add_snippets("javascript", js_snippets)
luasnip.add_snippets("typescript", js_snippets)
luasnip.add_snippets("javascriptreact", js_snippets)
luasnip.add_snippets("typescriptreact", js_snippets)
