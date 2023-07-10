/*
Copyright 2021 FXcoder

This file is part of VP.

VP is free software: you can redistribute it and/or modify it under the terms of the GNU General
Public License as published by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

VP is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
Public License for more details.

You should have received a copy of the GNU General Public License along with VP. If not, see
http://www.gnu.org/licenses/.
*/

// VP levels parameters. © FXcoder

#property strict

class CVPServiceParams
{
public:

	const bool    show_horizon;
	const string  id;


public:

	void CVPServiceParams(
		bool show_horizon_,
		string id_
	):
		show_horizon(show_horizon_),
		id(id_)
	{
	}

	// copy constructor
	void CVPServiceParams(
		const CVPServiceParams &p
	):
		show_horizon(p.show_horizon),
		id(p.id)
	{
	}

};
