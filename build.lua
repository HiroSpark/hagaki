module = "hagaki"

installfiles  = {"*.cls"}
sourcefiles   = {"*.cls"}

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

function update_tag(file, content, tagtype, tagdate)
  -- タグの作成
  local handle = assert(
    io.popen("git describe --tags --abbrev=0"),
    "最新のタグを取得できませんでした"
  )
  local current = handle:read("a") handle:close()
  local major, minor, patch = assert(string.match(current, "v(%d-)%.(%d-)%.(%d+)"))
  -- バージョンを更新
  if tagtype == "major" then
    major = math.tointeger(major + 1)
    minor = 0
    patch = 0
  elseif tagtype == "minor" then
    minor = math.tointeger(minor + 1)
    patch = 0
  elseif tagtype == "patch" then
    patch = math.tointeger(patch + 1)
  else
    error("tag のタイプは、major/minor/patch のいずれかにしてください")
  end
  tagname = major .. "." .. minor .. "." .. patch
  -- タグを更新
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

function tag_hook()
  os.execute("git commit -a -m 'chore: バージョンを v" .. tagname .. " に更新'")
  os.execute("git tag v" .. tagname)
end