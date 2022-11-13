function Image(img)
      if img.classes:find('filter',1) then
        local f = io.open("contribution/" .. img.src, 'r')
        local doc = pandoc.read(f:read('*a'))
        f:close()
        local caption = pandoc.utils.stringify(doc.meta.caption) --or "Epigraph has not been set"
        local student = pandoc.utils.stringify(doc.meta.student)   --or "Person has not been set"
        local id = pandoc.utils.stringify(doc.meta.id)
        local comment = "> " .. caption .. "\nName:" .. student .. " AM: " .. id
        return pandoc.RawInline('markdown',comment)
      end
end
