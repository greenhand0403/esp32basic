-- scale-images.lua
-- 仅当图片尺寸超过阈值时缩放；对 LaTeX 使用 \linewidth 比例，避免小图被放大
-- 需要 ImageMagick 7+ 在 PATH 中（magick identify）

-- 超过此像素阈值才视为“大图”
local MAX_PX = 200

-- 资源搜索路径（按你的项目实际增删）
local RESOURCE_PATHS = {
  ".", "001-020"
}

-- 在多个路径中寻找实际文件
local function find_file(rel)
  -- 绝对路径直接返回
  if rel:match("^%a:[/\\]") then return rel end
  for _, p in ipairs(RESOURCE_PATHS) do
    local full = p .. "/" .. rel
    local f = io.open(full, "rb")
    if f then f:close(); return full end
  end
  return rel
end

-- 用 ImageMagick 读取像素宽高（Windows: 2>nul；mac/Linux: 改 2>/dev/null）
local function get_image_size(path)
  local cmd = 'magick identify -format "%w %h" "' .. path .. '" 2>nul'
  local h = io.popen(cmd)
  if not h then return nil, nil end
  local out = h:read("*a") or ""
  h:close()
  local w, hgt = out:match("(%d+)%s+(%d+)")
  if not w then return nil, nil end
  return tonumber(w), tonumber(hgt)
end

function Image(img)
  -- 有显式 width 的保持不动；远程图跳过
  if img.attributes["width"] then return img end
  if img.src:match("^https?://") then return img end

  -- 找真实路径并测尺寸
  local real = find_file(img.src)
  local w, h = get_image_size(real)
  if not w or not h then
    -- 调试时可打开下一行看问题
    -- print("identify failed for", img.src, "->", real)
    return img
  end

  -- 只缩“大图”
  if math.max(w, h) > MAX_PX then
    if FORMAT:match("latex") then
      -- PDF：用版心比例，真正缩小，不会放大小图
      img.attributes["width"] = "0.7\\linewidth"
    else
      -- 其它（HTML/Docx）：用百分比
      img.attributes["width"] = "70%"
    end
  end
  return img
end