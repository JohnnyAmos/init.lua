-- printt <<<
--[[
A simple function to print tables or to write tables into files.
Great for debugging but also for data storage.
When writing into files the 'return' keyword will be added automatically,
so the tables can be loaded with 'dofile()' into a variable.
The basic datatypes table, string, number, boolean and nil are supported.
The tables can be nested and have number and string indices.
This function has no protection when writing files without proper permissions and
when datatypes other then the supported ones are used.

t = table
f = filename (optional)
--]]
function printt(t, f)

   local function printTableHelper(obj, cnt)

      local cnt = cnt or 0

      if type(obj) == "table" then

         io.write("\n", string.rep("\t", cnt), "{\n")
         cnt = cnt + 1

         for k,v in pairs(obj) do

            if type(k) == "string" then
               io.write(string.rep("\t",cnt), '["'..k..'"]', ' = ')
            end

            if type(k) == "number" then
               io.write(string.rep("\t",cnt), "["..k.."]", " = ")
            end

            printTableHelper(v, cnt)
            io.write(",\n")
         end

         cnt = cnt-1
         io.write(string.rep("\t", cnt), "}")

      elseif type(obj) == "string" then
         io.write(string.format("%q", obj))

      else
         io.write(tostring(obj))
      end 
   end

   if f == nil then
      printTableHelper(t)
   else
      io.output(f)
      io.write("return")
      printTableHelper(t)
      io.output(io.stdout)
   end
end -- >>>
-- rpt <<<
--[[
remove words with length 2 to 4
local S = "a bb ccc dddd eeeee"
print(S:gsub("%f[%a]".. rpt("%a",2,4) .."%f[%A]", ""))
if Lua had classic repitions for regex then the line would be
print(S:gsub("%f[%a]%a{2,4}%f[%A]", ""))

s   = regex atomic to repeat
m,n = repitition range
--]]
function rpt(s,m,n)
   return s:rep(m) .. (s..'?'):rep(n-m)
end -- >>>
-- readf <<<
--[[
readf reads a file and returns the content as a table with one line per index.
if the file was not readable readf returns nil.

f = filename
--]]
function readf(f)

   if (type(f) ~= "string") then
      return nil
   end

   local File_t = {}
   local File_h = io.open(f)

   if File_h then
      for l in File_h:lines() do
         table.insert(File_t, (string.gsub(l, "[\n\r]+$", "")))
      end
      File_h:close()
      return File_t
   end

   return nil
end -- >>>
--[[
writef takes a table or string and writes it to a file and returns true if writing was successful, otherwise nil.
If t is a table it shall contain numerical indices (1 to n) with strings as values, and no nil values in-between.

t = table or string containing file lines
f = filename
n = newline character (optional, default is "\n")
m = write mode ["w"|"a"|"w+"|"a+"] (optional, default is "w")
--]]
function writef(t, f, n, m)

   local n = n or "\n"
   local m = m or "w"

   if (type(t) ~= "table") and (type(t) ~= "string") then
      return nil
   end

   if (type(f) ~= "string") then
      return nil
   end

   if (type(n) ~= "string") then
      return nil
   end

   if (type(m) ~= "string") or (not string.match(m, "^[wa]%+?$")) then
      return nil
   end

   local File_h = io.open(f, m)
   if File_h then
      for _,l in ipairs(t) do
         File_h:write(l)
         File_h:write(n)
      end
      File_h:close()
      return true
   end
   return nil
end

-- vim: fmr=<<<,>>> fdm=marker
