all

# Set list indent level to 4 which Python-Markdown requires
rule 'MD007', :indent => 4

# Disable line length check for tables and code blocks
rule 'MD013', :line_length => 3000, :ignore_code_blocks => true, :tables => false

# Configure special behavior for MD026
rule 'MD026', :punctuation => '.,:;'

# Set Ordered list item prefix to "ordered" (use 1. 2. 3. not 1. 1. 1.)
rule 'MD029', :style => "ordered"

# Exclude code block style
exclude_rule 'MD046'

# This is broken when list items have line breaks in (would be good to fix and put back though...)
exclude_rule 'MD032'

# Exclude in-line HTML, need it for multi line entries in tables (at least)
exclude_rule 'MD033'

# Bare URLs are required in internal documentaion
exclude_rule 'MD034'

# Subjective.
exclude_rule 'MD036'

# Table header separation giving false positive
exclude_rule 'MD057'
