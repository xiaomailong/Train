with Ada.Containers.Vectors;

package Switch.Vectors is new Ada.Containers.Vectors
  (
   Index_Type => Types.Index_Type,
   Element_Type => Object,
   "=" => Switch."="
  );
