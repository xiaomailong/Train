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

with Track.Switch_Operations;

package body Track is

   procedure Switch_Lookout
     (Position    : in Switch.Vectors.Cursor;
      S           : in out Segment.Vectors.Cursor;
      S_Extremity : in out Segment.Extremity;
      Found       : out Boolean);

   function Create return Object is
   begin
      return Object'
        (Segments => Segment.Vectors.Empty_Vector,
         Switchs  => Switch.Vectors.Empty_Vector);
   end Create;

   procedure Add_Unlinked_Segment
     (This        : in out Object;
      New_Segment : Segment.Object;
      Cursor      : out Segment.Vectors.Cursor) is
      use type Segment.Vectors.Vector;
   begin
      This.Segments := This.Segments & New_Segment;
      Cursor        := This.Segments.Last;
   end Add_Unlinked_Segment;

   procedure Add_Switch
     (This       : in out Object;
      New_Switch : Switch.Object;
      Cursor     : out Switch.Vectors.Cursor) is
      use type Switch.Vectors.Vector;
   begin
      This.Switchs := This.Switchs & New_Switch;
      Cursor       := This.Switchs.Last;
   end Add_Switch;

   procedure Add_Link
     (This          : in out Object;
      S1            : Segment.Vectors.Cursor;
      S1_Extremity  : Segment.Extremity;
      Link_Switch   : Switch.Vectors.Cursor;
      Link_Position : Switch.Position;
      S2            : Segment.Vectors.Cursor;
      S2_Extremity  : Segment.Extremity) is
      Actual_Switch : Switch.Object := Switch.Vectors.Element (Link_Switch);
   begin
      Actual_Switch.Add_Branch
        (S1,
         S1_Extremity,
         Link_Position,
         S2,
         S2_Extremity);
      This.Switchs.Replace_Element (Link_Switch, Actual_Switch);
   end Add_Link;

   procedure Switch_Lookout
     (Position    : in Switch.Vectors.Cursor;
      S           : in out Segment.Vectors.Cursor;
      S_Extremity : in out Segment.Extremity;
      Found       : out Boolean) is
      use type Segment.Vectors.Cursor;
      use type Segment.Extremity;
      Element : constant Switch.Object := Switch.Vectors.Element (Position);
   begin
      Found := False;

      if Element.Is_Set
      then
         if Element.Connexion.S1 = S and
            Element.Connexion.S1_Extremity = S_Extremity
         then
            Found       := True;
            S           := Element.Connexion.S2;
            S_Extremity := Element.Connexion.S2_Extremity;
         elsif Element.Connexion.S2 = S and
               Element.Connexion.S2_Extremity = S_Extremity
         then
            Found       := True;
            S           := Element.Connexion.S1;
            S_Extremity := Element.Connexion.S1_Extremity;
         end if;
      end if;

   end Switch_Lookout;

   function Is_Linked
     (This        : in Object;
      S           : in Segment.Vectors.Cursor;
      S_Extremity : in Segment.Extremity)
      return        Boolean
   is
      Found : Boolean := False;
      procedure Switch_Iteration (Position : in Switch.Vectors.Cursor) is
         S_I           : Segment.Vectors.Cursor := S;
         S_Extremity_I : Segment.Extremity      := S_Extremity;
      begin
         if not Found
         then
            Switch_Lookout (Position, S_I, S_Extremity_I, Found);
         end if;
      end Switch_Iteration;
   begin
      This.Switchs.Iterate (Switch_Iteration'Access);
      return Found;
   end Is_Linked;

   procedure Next
     (This        : in Object;
      S           : in out Segment.Vectors.Cursor;
      S_Extremity : in out Segment.Extremity) is
      Found : Boolean := False;
      procedure Switch_Iteration (Position : in Switch.Vectors.Cursor) is
      begin
         if not Found
         then
            Switch_Lookout (Position, S, S_Extremity, Found);
         end if;
      end Switch_Iteration;
   begin
      This.Switchs.Iterate (Switch_Iteration'Access);

      -- Be careful, we got the extremity linked by the switch,
      -- not the extremity in the same global direction than input.
      -- We need to get the opposite one.
      S_Extremity := Segment.Opposite_Extremity (S_Extremity);
   end Next;

   function Relative_Extremity
     (This               : Object;
      Reference          : Segment.Vectors.Cursor;
      Location           : Segment.Vectors.Cursor;
      Location_Extremity : Segment.Extremity)
      return               Segment.Extremity
   is
      use type Segment.Vectors.Cursor;

      Cursor           : Segment.Vectors.Cursor;
      Cursor_Extremity : Segment.Extremity;
   begin

      Cursor           := Location;
      Cursor_Extremity := Location_Extremity;
      while Cursor /= Reference
        and then This.Is_Linked (Cursor, Cursor_Extremity)
      loop
         This.Next (Cursor, Cursor_Extremity);

         -- Exit in case of loop
         exit when Cursor = Location;
      end loop;

      if Cursor = Reference
      then
         return Cursor_Extremity;
      end if;

      Cursor           := Location;
      Cursor_Extremity := Segment.Opposite_Extremity (Location_Extremity);
      while Cursor /= Reference
        and then This.Is_Linked (Cursor, Cursor_Extremity)
      loop
         begin
            This.Next (Cursor, Cursor_Extremity);
         end;
      end loop;

      if Cursor = Reference
      then
         return Segment.Opposite_Extremity (Cursor_Extremity);
      end if;

      raise No_Next_Segment;

   end Relative_Extremity;

   procedure End_Of_Route
     (This        : Object;
      S           : in out Segment.Vectors.Cursor;
      S_Extremity : in out Segment.Extremity) is
      use type Segment.Vectors.Cursor;
      Cursor           : Segment.Vectors.Cursor := S;
      Cursor_Extremity : Segment.Extremity      := S_Extremity;
   begin
      while This.Is_Linked (Cursor, Cursor_Extremity)
      loop
         This.Next (Cursor, Cursor_Extremity);
         exit when Cursor = S;
      end loop;

      if This.Is_Linked (Cursor, Cursor_Extremity)
      then
         raise Unexpected_Loop;
      else
         S           := Cursor;
         S_Extremity := Cursor_Extremity;
      end if;
   end End_Of_Route;

   -- From switch_operation child package

   procedure Unset (This : in out Object; S : Switch.Vectors.Cursor) renames
     Track.Switch_Operations.Unset;
   procedure Set
     (This            : in out Object;
      S               : Switch.Vectors.Cursor;
      Switch_Position : Switch.Position) renames Track.Switch_Operations.Set;

   function Element (S : Segment.Vectors.Cursor) return Segment.Object is
   begin
      return Segment.Vectors.Element (S);
   end Element;

   function Element (S : Switch.Vectors.Cursor) return Switch.Object is
   begin
      return Switch.Vectors.Element (S);
   end Element;

end Track;
