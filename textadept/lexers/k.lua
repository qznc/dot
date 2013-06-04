-- Copyright 2013 Andreas Zwinkau <qznc@web.de>. See LICENSE.
-- K-Framework LPeg lexer.

local l = lexer
local token = l.token
local P, R, S = lpeg.P, lpeg.R, lpeg.S

-- Comment.
local line_comment = '//' * l.nonnewline_esc^0
local block_comment = '/*' * (l.any - '*/')^0 * P('*/')^-1
local comment = token(l.COMMENT, line_comment + block_comment)

-- Strings.
local sq_str = P('L')^-1 * l.delimited_range("'", '\\', true, false, '\n')
local dq_str = P('L')^-1 * l.delimited_range('"', '\\', true, false, '\n')
local string = token(l.STRING, sq_str + dq_str)

-- Keywords.
local keyword = token(l.KEYWORD, l.word_match{
  'syntax', 'rule', 'module', 'endmodule', 'imports',
  'KResult', 'require'
})

-- Identifiers.
local nonterminals = l.upper * l.word
local config_tags = '<' * (l.any - '>')^0 * P('>')^-1
local identifier = token(l.IDENTIFIER, nonterminals + config_tags)

-- Operators.
local long_ops = l.word_match({"=>", "::=", "~>"}, "=>:~")
local operator = token(l.OPERATOR, long_ops + S("|>:_[](),/"))

local M = {_NAME = 'k'}

M._rules = {
  {'whitespace', token(l.WHITESPACE, l.space^1)},
  {'comment', comment},
  {'keyword', keyword},
  {'identifier', identifier},
  {'string', string},
  {'operator', operator},
  {'any_char', l.any_char},
}

M._foldsymbols = {
  _patterns = {'%l+', '[{}]', '/%*', '%*/', '//'},
    [l.OPERATOR] = {['{'] = 1, ['}'] = -1},
    [l.COMMENT] = {['/*'] = 1, ['*/'] = -1, ['//'] = l.fold_line_comments('//')}
}

return M
