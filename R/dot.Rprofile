setHook(packageEvent("grDevices", "onLoad"),function(...) grDevices::pdf.options(family="Japan1"))
setHook(packageEvent("grDevices", "onLoad"),function(...) grDevices::ps.options(family="Japan1"))
setHook(packageEvent("grDevices", "onLoad"),
        function(...){
            grDevices::quartzFonts(serif=grDevices::quartzFont(
                c("Hiragino Mincho Pro W3",
                  "Hiragino Mincho Pro W6",
                  "Hiragino Mincho Pro W3",
                  "Hiragino Mincho Pro W6")))
            grDevices::quartzFonts(sans=grDevices::quartzFont(
                c("Hiragino Kaku Gothic Pro W3",
                  "Hiragino Kaku Gothic Pro W6",
                  "Hiragino Kaku Gothic Pro W3",
                  "Hiragino Kaku Gothic Pro W6")))
        }
)
attach(NULL, name = "MacJapanEnv")
assign("familyset_hook",
       function() { if(names(dev.cur())=="quartz") par(family="serif")},
       pos="MacJapanEnv")
setHook("plot.new", get("familyset_hook", pos="MacJapanEnv"))
