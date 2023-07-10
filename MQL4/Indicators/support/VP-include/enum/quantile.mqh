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

// Квантили. © FXcoder

#property strict

enum ENUM_QUANTILE
{
	QUANTILE_NONE   = 0x0100,  // No quantiles or median
	//QUANTILE_CUSTOM = 0x0200,  // Custom quantiles...

	QUANTILE_MEDIAN     = 0x1100,  // Median
	QUANTILE_QUARTILES  = 0x1200,  // Quartiles
	QUANTILE_DECILES    = 0x1300,  // Deciles

	QUANTILE_70     = 0x2100,  // 70%: 15% - 50%(Median) - 85%
	QUANTILE_95     = 0x2200,  // 95%: 2.5% - 50%(Median) - 97.5%
	QUANTILE_99     = 0x2300,  // 99%: 0.5% - 50%(Median) - 99.5%
};

int EnumQuantileToArray(ENUM_QUANTILE q, double &quantiles[])
{
	switch (q)
	{
		case QUANTILE_NONE:
			ArrayResize(quantiles, 0);
			return(0);

		case QUANTILE_MEDIAN:
			ArrayResize(quantiles, 1);
			quantiles[0] = 0.50;
			return(1);

		case QUANTILE_QUARTILES:
			ArrayResize(quantiles, 3);
			quantiles[0] = 0.25;
			quantiles[1] = 0.50;
			quantiles[2] = 0.75;
			return(3);

		case QUANTILE_DECILES:
			ArrayResize(quantiles, 9);
			quantiles[0] = 0.1;
			quantiles[1] = 0.2;
			quantiles[2] = 0.3;
			quantiles[3] = 0.4;
			quantiles[4] = 0.5;
			quantiles[5] = 0.6;
			quantiles[6] = 0.7;
			quantiles[7] = 0.8;
			quantiles[8] = 0.9;
			return(9);

		case QUANTILE_70:
			ArrayResize(quantiles, 3);
			quantiles[0] = 0.15;
			quantiles[1] = 0.50;
			quantiles[2] = 0.85;
			return(3);

		case QUANTILE_95:
			ArrayResize(quantiles, 3);
			quantiles[0] = 0.025;
			quantiles[1] = 0.500;
			quantiles[2] = 0.975;
			return(3);

		case QUANTILE_99:
			ArrayResize(quantiles, 3);
			quantiles[0] = 0.005;
			quantiles[1] = 0.500;
			quantiles[2] = 0.995;
			return(3);
	}

	ArrayResize(quantiles, 0);
	return(0);
}
