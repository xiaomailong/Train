--  Copyright \copy 2013 Baptiste Fouques

--  This program  is free  software: you  can redistribute  it and/or  modify it
--  under the terms of  the GNU General Public License as  published by the Free
--  Software Foundation,  either version 3 of  the License, or (at  your option)
--  any later version.

--  This program is distributed in the hope  that it will be useful, but WITHOUT
--  ANY  WARRANTY;  without even  the  implied  warranty of  MERCHANTABILITY  or
--  FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU General Public  License for
--  more details.

--  You should have received a copy of the GNU General Public License along with
--  this program.  If not, see http://www.gnu.org/licenses/.

with Types;

with Track;
with Segment;
with Segment.Vectors;
with Segment.Ends;
with Switch;
with Switch.Vectors;
with Location;
with Location.Oriented;
with Location.Topo;

procedure Test_Track is

   Test_Fail : exception;

   procedure Eyebrown is
      Eyebrown_Shape : aliased Track.Object := Track.Create;
      Size : constant array (Positive range <>) of Types.Length
        := (1=>5.0, 2=>15.0, 3=>25.0, 4=>5.0);

      Main_Segment : Segment.Vectors.Cursor;
      Upstream_Switch, Downstream_Switch : Switch.Vectors.Cursor;

      L1, L1p, L2, L3 : Location.Object;
      Abscs : constant array (Positive range <>) of Types.Abscissa
        := (1=>1.0, 2=>3.0, 3=>10.0);
      -- Expected_Distances
      L1_L2_By_Main : constant := 22.0;
      L1_L2_By_High : constant := 32.0;
      L1_L3 : constant := 19.0;
      -- Negation because High (L3) reverse the reference from L1 and L2
      L3_L2 : constant := - (L1_L2_By_High - L1_L3);

      package Eyebrown_Topology is new Location.Topo (Eyebrown_Shape'access);
      use Eyebrown_Topology;

      use type Types.Meter_Precision_Millimeter;

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

      -- Test location comparaison
      L1p := Location.Object (L2 +
                                (- L2.Abscissa
                                   - Size(1) - Size(2)
                                   + L1.Abscissa));
      if L1 /= L2 then
         -- Test OK
         null;
      else
         raise Test_Fail;
      end if;
      if L1p = L1 then
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
   end Eyebrown;

   procedure Circle
   is
      Circle_Line : aliased Track.Object := Track.Create;
      Size : constant array (Positive range <>) of Types.Length
        := (1=>25.0, 2=>25.0, 3=>35.0);
      S1, S2 : Switch.Vectors.Cursor;
      L1, L2, High : Segment.Vectors.Cursor;
      Signal_1_S, Signal_1_N, Signal_1_R,
        Signal_2_S, Signal_2_N, Signal_2_R : Location.Oriented.Object;

      To_Switch : constant := 5.0;

      use type Types.Meter_Precision_Millimeter;

      package Topology is new Location.Topo (Circle_Line'access);
      use Topology;

   begin

      Circle_Line.Add_Unlinked_Segment (Segment.Create (Size(1)), L1);
      Circle_Line.Add_Unlinked_Segment (Segment.Create (Size(2)), L2);
      Circle_Line.Add_Unlinked_Segment (Segment.Create (Size(3)), High);

      Circle_Line.Add_Switch (Switch.Create, S1);
      Circle_Line.Add_Switch (Switch.Create, S2);

      Circle_Line.Add_Link (
                            L1, Segment.Incrementing,
                            S1, 1,
                            L2, Segment.Decrementing
                           );
      Circle_Line.Add_Link (
                            L2, Segment.Incrementing,
                            S2, 1,
                            L1, Segment.Decrementing
                           );
      Circle_Line.Add_Link (
                            L2, Segment.Incrementing,
                            S2, 2,
                            High, Segment.Incrementing
                           );
      Circle_Line.Add_Link (
                            High, Segment.Decrementing,
                            S1, 2,
                            L2, Segment.Decrementing
                           );

      -- Create Signals
      Signal_1_S := Location.Oriented.Object
        (Segment.Ends.Zero (L2) - To_Switch);
      Signal_1_N := Location.Oriented.Object
        (Segment.Ends.Max(L1) - To_Switch);
      Signal_1_R := Location.Oriented.Object
        (Segment.Ends.Zero (High) - To_Switch);

      Signal_2_S := Location.Oriented.Object
        (Segment.Ends.Max(L2) - To_Switch);
      Signal_2_N := Location.Oriented.Object
        (Segment.Ends.Zero(L1) - To_Switch);
      Signal_2_R := Location.Oriented.Object
        (Segment.Ends.Max(High) - To_Switch);

      Circle_Line.Set (S1, 1);
      Circle_Line.Set (S2, 2);

      if Signal_1_N < Signal_2_S
        and Signal_2_S < Signal_1_R
      then
         -- Test OK
         null;
      else
         raise Test_Fail;
      end if;

      if Signal_2_R < Signal_1_S
        and Signal_1_S < Signal_2_N
      then
         -- Test OK
         null;
      else
         raise Test_Fail;
      end if;

      if Signal_1_S < Signal_2_N.Non_Oriented
        and Signal_2_N.Non_Oriented < Signal_1_S
        and Signal_2_N.Non_Oriented < Signal_1_S.Non_Oriented
      then
         -- Test OK
         null;
      else
         raise Test_Fail;
      end if;

      -- Error detection test
      begin
         if Signal_1_N < Signal_2_R
         then
            raise Test_Fail;
         end if;

         raise Test_Fail;

      exception
         when Location.Oriented.Location_Are_Not_Comparable =>
            -- Test Ok
            null;
      end;

      Circle_Line.Set (S1, 1);
      Circle_Line.Set (S2, 1);

      -- Error detection test
      begin
         if Signal_1_N < Signal_2_S
         then
            raise Test_Fail;
         end if;

         raise Test_Fail;

      exception
         when Track.Unexpected_Loop =>
            -- Test Ok
            null;
      end;

      if Signal_2_S - Signal_1_N = Track.Element(L2).Max_Abscissa
      then
         -- Test OK
         null;
      else
         raise Test_Fail;
      end if;

      if Signal_1_N - Signal_2_S = Track.Element(L1).Max_Abscissa
      then
         -- Test OK
         null;
      else
         raise Test_Fail;
      end if;

   end Circle;

begin

   Eyebrown;

   Circle;

end Test_Track;
