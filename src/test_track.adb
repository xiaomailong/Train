with Types;

with Track;
with Segment;
with Segment.Vectors;
with Switch;
with Switch.Vectors;
with Location;

procedure Test_Track is
   Eyebrown_Shape : Track.Object := Track.Create;
   Size : constant array (Positive range <>) of Types.Length
     := (1=>5.0, 2=>15.0, 3=>25.0, 4=>5.0);

   Main_Segment : Segment.Vectors.Cursor;
   Upstream_Switch, Downstream_Switch : Switch.Vectors.Cursor;

   L1, L2, L3 : Location.Object;
   Abscs : constant array (Positive range <>) of Types.Abscissa
     := (1=>1.0, 2=>3.0, 3=>10.0);
   -- Expected_Distances
   L1_L2_By_Main : constant := 22.0;
   L1_L2_By_High : constant := 32.0;
   L1_L3 : constant := 19.0;
   -- Negation because High (L3) reverse the reference from L1 and L2
   L3_L2 : constant := - (L1_L2_By_High - L1_L3);

   use type Types.Meter_Precision_Millimeter;

   Test_Fail : exception;
begin

   Eyebrown_Shape.Add_Unlinked_Segment (Segment.Create (Size(2)), Main_Segment);
   Eyebrown_Shape.Add_Switch (Switch.Create, Upstream_Switch);
   Eyebrown_Shape.Add_Switch (Switch.Create, Downstream_Switch);

   declare
      Down_Segment, Up_Segment, High_Segment : Segment.Vectors.Cursor;
   begin
      Eyebrown_Shape.Add_Unlinked_Segment (Segment.Create (Size(1)),
                                           Down_Segment);
      Eyebrown_Shape.Add_Unlinked_Segment (Segment.Create (Size(3)),
                                           High_Segment);
      Eyebrown_Shape.Add_Unlinked_Segment (Segment.Create (Size(4)),
                                           Up_Segment);

      L1 := Location.Create (Up_Segment, Abscs (1));
      L2 := Location.Create (Down_Segment, Abscs (2));
      L3 := Location.Create (High_Segment, Abscs (3));

      Eyebrown_Shape.Add_Link
        (
         Up_Segment, Segment.Incrementing,
         Upstream_Switch, 1,
         Main_Segment, Segment.Decrementing
        );
      Eyebrown_Shape.Add_Link
        (
         Up_Segment, Segment.Incrementing,
         Upstream_Switch, 2,
         High_Segment, Segment.Incrementing
        );
      Eyebrown_Shape.Add_Link
        (
         Main_Segment, Segment.Incrementing,
         Downstream_Switch, 1,
         Down_Segment, Segment.Decrementing
        );
      Eyebrown_Shape.Add_Link
        (
         High_Segment, Segment.Decrementing,
         Downstream_Switch, 2,
         Down_Segment, Segment.Decrementing
        );
   end;

   -- Test Abscissa computation
   -- by main
   Eyebrown_Shape.Set (Upstream_Switch, 1);
   Eyebrown_Shape.Set (Downstream_Switch, 1);
   if L2.Abscissa (Eyebrown_Shape, L1.Reference) - L1.Abscissa
     = L1_L2_By_Main
   then
      -- Test OK
      null;
   else
      raise Test_Fail;
   end if;

   -- Test Abscissa computation
   -- by hg
   Eyebrown_Shape.Set (Upstream_Switch, 2);
   Eyebrown_Shape.Set (Downstream_Switch, 2);
   if L2.Abscissa (Eyebrown_Shape, L1.Reference) - L1.Abscissa
     = L1_L2_By_High
   then
      -- Test OK
      null;
   else
      raise Test_Fail;
   end if;
   if L2.Abscissa (Eyebrown_Shape, L3.Reference) - L3.Abscissa
     = L3_L2
   then
      -- Test OK
      null;
   else
      raise Test_Fail;
   end if;
   if L3.Abscissa (Eyebrown_Shape, L1.Reference) - L1.Abscissa
     = L1_L3
   then
      -- Test OK
      null;
   else
      raise Test_Fail;
   end if;

end Test_Track;
