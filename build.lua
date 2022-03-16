module = "hagaki"

installfiles  = {"*.cls"}

checkformat   = "latex"
checkengines  = {"luatex"}

-- ドキュメントの生成

typesetexe    = "lualatex"
typesetopts   = ""
docfiledir    = "doc"
typesetfiles  = {"hagaki.tex"}
typesetdemofiles = {"example.tex"}
typesetsourcefiles = {"hagaki-doc.cls"}

function typeset(file, dir)
  local dir = dir or "."
  local cmd = typesetexe .. " " .. typesetopts
  return runcmd(cmd .. " " .. file, dir, {"TEXINPUTS"})
end

-- バージョンの自動更新

tagfiles = {"hagaki.cls", "doc/hagaki.tex"}

function update_tag(file, content, tagname, tagdate)
  tagdate = string.gsub(tagdate, "-", "/")
  if string.match(file, "%.tex$") then
    return string.gsub(
      content,
      "\\date{.-（.-）}",
      "\\date{v" .. tagname .. "（" .. tagdate .. "）}"
    )
  elseif string.match(file, "%.cls$") then
    return string.gsub(
      content,
      "\\ProvidesExplClass{(.-)}{.-}{.-}",
      "\\ProvidesExplClass{%1}{" .. tagdate .. "}{" .. tagname .. "}"
    )
  end
  return content
end

function tag_hook(tagname)
  os.execute("git commit -a -m 'chore: バージョンを v" .. tagname .. " に更新'")
  os.execute("git v" .. tagname)
end