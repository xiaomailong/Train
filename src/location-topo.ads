generic
   Current_Track : access constant Track.Object;
package Location.Topo is

   function "=" (Left, Right : Object'Class) return Boolean;

   function "<" (Left, Right : Object'Class) return Boolean;

   function "+" (Left : Object'Class; Right : Types.Abscissa) return Object'Class;

   function "-" (Left : Object'Class; Right : Types.Abscissa) return Object'Class;

   function "-" (Left, Right : Object'Class) return Types.Abscissa;

end Location.Topo;
