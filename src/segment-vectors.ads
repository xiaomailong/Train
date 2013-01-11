with Types;

with Ada.Containers.Vectors;

package Segment.Vectors is new Ada.Containers.Vectors
  (
   Index_Type => Types.Index_Type,
   Element_Type => Object,
   "=" => Segment."="
  );
