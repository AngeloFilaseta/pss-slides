#!/usr/bin/env ruby
replacements = {
    /^%.*$/ => -> { '' },
    "\\`E" => -> { "È" },
    /\\section{([^}]*)}/ => -> { "\n# #{$1}\n\n---\n" },
    /\\alert\s*(\{([^}{]+|\g<1>)*\})/ => -> { "*__#{$2}__*" },
    /``(.*)(''|")/ => -> { "\"#{$1}\"" },
    /"(.*)('')/ => -> { "\"#{$1}\"" },
    /\\texttt\s*(\{([^}{]+|\g<1>)*\})/ => -> { "`#{$2}`" },
    /\\cil\s*(\{([^}{]+|\g<1>)*\})/ => -> { "`#{$2}`" },
    /\\Cil\s*(\{([^}{]+|\g<1>)*\})/ => -> { "`#{$2}`" },
    /\\(text)?bf\s*(?<content>\{([^}{]+|\g<content>)*\})/ => -> { "**#{$~[:content][1...-1]}**" },
    /\\textit\s*(\{([^}{]+|\g<1>)*\})/ => -> { "*#{$2}*" },
    /\\(my)?url\s*(\{([^}{]+|\g<1>)*\})/ => -> { "#{$3}" },
    /\\emph\s*(\{([^}{]+|\g<1>)*\})/ => -> { "*#{$2}*" },
    /\\item\s*(\[(.*)\])?\s+/ => -> { "* #{$2} " },
    /\\(iz|en)\s*(?<content>\{([^}{]+|\g<content>)*\})/ => -> { "\n#{$~[:content][1...-1]}\n" },
    /\\bl\s*(?<title>\{([^}{]+|\g<title>)*\})\s*(?<content>\{([^}{]+|\g<content>)*\})/m => -> {
        "\n### #{$~[:title][1...-1]}\n\n#{$~[:content][1...-1]}\n"
    },
    /\\bx\s*(?<content>\{([^}{]+|\g<content>)*\})/m => -> { "\n#{$~[:content][1...-1]}\n" },
    /\\fr(s\{[^}]*\})?\s*(?<title>\{([^}{]+|\g<title>)*\})\s*(?<content>\{([^}{]+|\g<content>)*\})/m => -> {
        "\n## #{$~[:title][1...-1]}\n\n#{$~[:content][1...-1]}\n\n---"
    },
    /\{\\bf\s+(?<content>[^}]*)}/  => -> { "**#{$~[:content]}**" },
    '\\\\' => -> { '<br>' },
    '\\%' => -> { '%' },
    '\\_' => -> { '_' },
    /\\fg\s*(?<options>\{([^}{]+|\g<options>)*\})?\s*(?<path>\{([^}{]+|\g<path>)*\})?/ => -> {
        "![](#{$~[:path][1...-1]})"
    },
}
files = ARGV
for file_name in files do
    old_text = File.read(file_name)
    loop do
        new_text = old_text
        for matcher, replacement in replacements do
            new_text = new_text.gsub(matcher) { replacement.call }
        end
        break if old_text == new_text
        old_text = new_text
    end 
    File.open(file_name, "w") {|file| file.puts old_text }
end
