generic
   Current_Track : Track.Object;
package Location.Topo is

   function "=" (Left, Right : Object) return Boolean;

   function ">" (Left, Right : Object) return Boolean;

   function "+" (Left : Object; Right : Types.Abscissa) return Object;

   function "-" (Left : Object; Right : Types.Abscissa) return Object;

   function "-" (Left, Right : Object) return Types.Abscissa;

end Location.Topo;
