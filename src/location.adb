with Constants;

package body Location is

   function Create
     (Relative : Segment.Vectors.Cursor;
      Abscissa : Types.Abscissa)
     return Object
   is
   begin
      return Object'(
                     Reference_Segment => Relative,
                     Reference_Abscissa => Abscissa
                    );
   end Create;

   function Abscissa (This : Object)
                     return Types.Abscissa
   is
   begin
      return Abscissa (This, This.Reference_Segment);
   end Abscissa;


   function Reference (This : Object)
                      return Segment.Vectors.Cursor
   is
   begin
      return This.Reference_Segment;
   end Reference;

   function Abscissa (This : Object; Relative : in Segment.Vectors.Cursor)
                     return Types.Abscissa is
      use type Segment.Vectors.Cursor;
   begin
      if Relative = This.Reference_Segment
      then
         return This.Reference_Abscissa;
      else
         raise No_Link_With_Segment;
      end if;
   end Abscissa;

   function Abscissa (
                      This : Object;
                      Dynamic_Track : Track.Object;
                      Relative : in Segment.Vectors.Cursor
                     )
                     return Types.Abscissa
   is
      use type Types.Meter_Precision_Millimeter;
      use type Segment.Vectors.Cursor;

      Delta_Segment : Types.Length;
      Cursor : Segment.Vectors.Cursor;
      Cursor_Extremity : Segment.Extremity;
   begin

      Delta_Segment := 0.0;
      Cursor := This.Reference;
      Cursor_Extremity := Segment.Incrementing;
  Incrementing_Loop :
      while Cursor /= Relative
      loop
         begin
            Delta_Segment := Delta_Segment
              + Segment.Vectors.Element (Cursor).Max_Abscissa;

            Dynamic_Track.Next (Cursor, Cursor_Extremity);

         exception
            when Track.No_Next_Segment =>
               exit Incrementing_Loop;
         end;
      end loop Incrementing_Loop;

      if Cursor = Relative
      then
         case Cursor_Extremity is
            when Segment.Incrementing =>
              return This.Abscissa - Delta_Segment;
            when Segment.Decrementing =>
               return Segment.Vectors.Element (Cursor).Max_Abscissa
                 - (This.Abscissa - Delta_Segment);
         end case;
      end if;

      Delta_Segment := 0.0;
      Cursor := This.Reference;
      Cursor_Extremity := Segment.Decrementing;
  Decrementing_Loop :
      while Cursor /= Relative
      loop
         begin
            Dynamic_Track.Next (Cursor, Cursor_Extremity);
            Delta_Segment := Delta_Segment
              + Segment.Vectors.Element (Cursor).Max_Abscissa;

         exception
            when Track.No_Next_Segment =>
               raise No_Link_With_Segment;
         end;
      end loop Decrementing_Loop;

      if Cursor = Relative
      then
         case Cursor_Extremity is
            when Segment.Incrementing =>
               return
                 - (Delta_Segment
                      - Segment.Vectors.Element (Cursor).Max_Abscissa
                      + This.Abscissa);
            when Segment.Decrementing =>
               return Delta_Segment + This.Abscissa;
         end case;
      end if;

      raise No_Link_With_Segment;

   end Abscissa;

   function equal (A : Object; B : Object) return Boolean
   is
      use type Types.Meter_Precision_Millimeter;
   begin
      if A.Abscissa - B.Abscissa(Current_Track, A.Reference)
        in -Constants.Millimeter .. Constants.Millimeter
      then
         return True;
      else
         return False;
      end if;

   exception
      when No_Link_With_Segment =>
         return False;
   end equal;


end Location;
