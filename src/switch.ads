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

with Constants;
with Segment;
with Segment.Vectors;

with Ada.Containers;
with Ada.Containers.Hashed_Maps;

package Switch is

   type Object is tagged private;
   pragma Preelaborable_Initialization(Object);

   type Position is range 1 .. Constants.Switch_Position_Max_Id;
   type Link is
      record
         S1 : Segment.Vectors.Cursor;
         S1_Extremity : Segment.Extremity;
         S2 : Segment.Vectors.Cursor;
         S2_Extremity : Segment.Extremity;
      end record;

   -- Null switch is actually an and of track ...
   Buffer_Stop : constant Object;

   function Create return Object;
   procedure Add_Branch (
                        This : in out Object;
                        S1 : Segment.Vectors.Cursor;
                        S1_Extremity : Segment.Extremity;
                        Switch_Position : Position;
                        S2 : Segment.Vectors.Cursor;
                        S2_Extremity : Segment.Extremity
                       );

   procedure Unset (This : in out Object);
   function Is_Set (This : in Object) return Boolean;
   procedure Set (This : in out Object; Switch_Position : Position);
   function Connexion(This : Object) return Link;

   Unset_Switch : exception;

private

   function Id (Key : Position) return Ada.Containers.Hash_Type;
   package Branches_Map is new Ada.Containers.Hashed_Maps
     (
      Key_Type => Position,
      Element_Type => Link,
      Hash => Id,
      Equivalent_Keys => "=",
      "=" => "="
     );

   type Object is tagged
      record
         Is_Set : Boolean;
         Current_Position : Position;
         Branches : Branches_Map.Map;
      end record;

   Buffer_Stop : constant Object := Object'(
                                            Is_Set => False,
                                            Current_Position => Position'Last,
                                            Branches => Branches_Map.Empty_Map
                                           );

end Switch;
