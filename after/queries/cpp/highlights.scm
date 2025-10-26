;; C++20 modules: basic keyword highlighting
((import_declaration) @keyword)
((module_declaration) @keyword)
((export_declaration) @keyword)

;; Optional: color the module name itself
((module_declaration
   name: (module_name) @namespace))

((import_declaration
   (module_name) @namespace))
