module = "hagaki"

installfiles  = {"*.cls"}

docfiledir    = "doc"
typesetexe    = "lualatex"

checkformat   = "latex"
checkengines  = {"luatex"}

-- バージョンの自動更新

tagfiles = {"hagaki.cls", "doc/hagaki.tex"}

function update_tag(file, content, tagname, tagdate)
  tagdate = string.gsub(tagdate, "-", "/")
  if string.match(file, "%.tex$") then
    return string.gsub(
      content,
      "\n\\date{.-（.-）}",
      "\n\\date{v" .. tagname .. "（" .. tagdate .. "）}"
    )
  elseif string.match(file, "%.cls$") then
    return string.gsub(
      content,
      "\n\\ProvidesExplClass{(.-)}{%d%d%d%d/%d%d/%d%d}{%d.%d.%d}",
      "\n\\ProvidesExplClass{%1}{" .. tagdate .. "}{" .. tagname .. "}"
    )
  end
  return content
end

function tag_hook(tagname)
  os.execute("git commit -a -m 'chore: バージョンを v" .. tagname .. " に更新'")
  os.execute("git v" .. tagname)
end