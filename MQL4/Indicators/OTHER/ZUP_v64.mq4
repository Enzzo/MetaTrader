//|----------------------------------------------------------------------|
//|ZigZag ������������� � ���������� ���������                           |
//|----------------------------------------------------------------------|
//|                                                                      |
//|               "Parameters for ZigZag"                                |
//|                                                                      |
//|----------------------------------------------------------------------|
//|ExtIndicator - ����� �������� ����������, �� ������ ��������          |
//|               �������� �������� ���������                            |
//|           0 - Zigzag �� ������������, �����������                    |
//|           1 - Zigzag ������,                                         |
//|           2 - ��������� �������� ����������� � Ensign                |
//|           3 - ZigZag Ensign � ���������� ��������� minBars           |
//|           4 - ZigZag, ���������� tauber                              |
//|           5 - �������� �� ���� ������� �����                         |
//|           6 - DT-ZigZag � ������� ZigZag_new_nen3.mq4                |
//|           7 - DT-ZigZag � ������� DT_ZZ.mq4 (���������� klot)        |
//|           8 - DT-ZigZag � ������� CZigZag.mq4 (���������� Candid)    |
//|          10 - DT-ZigZag � ������� Swing_zz - ��� ExtIndicator=5      |
//|               � ������ DT                                            |
//|          11 - �������� ����� ��������� Gartley                       |
//|          12 - ZigZag, ���������� Talex                               |
//|          13 - SQZZ ������                                            |
//|                                                                      |
//|minBars - ������ ������� (�������� ���������� �����)                  |
//|minSize - ������ �� ���������� ������� (�������� ���������� �������)  |
//|                                                                      |
//|ExtDeviation � ExtBackstep - ��������� ���������� �� ZigZag �� MT4    |
//|                                                                      |
//|GrossPeriod - �������� ����������, ���������� � ������� (����� �����),|
//| ������ � �������� ������� ��� ���������� ZigZag � ������ DT-ZigZag   |
//|                                                                      |
//|minPercent - ���������� ������ (�������� �������, �������� 0.5)       |
//|             ���� ������������ �������� - ������� �����, � minSize=0; |
//|                                                                      |
//|ExtPoint=11 -   ���������� ����� ������� ��� ������� Talex            |
//|                                                                      |
//|ExtStyleZZ - = true - ������ ����� ����� ZigZag ����� ������� �����   |
//|             = false - Zigzag ��������� ������� � �����������         |
//|----------------------------------------------------------------------|
//|                                                                      |
//|               "Parameters for fibo Levels"                           |
//|                                                                      |
//|----------------------------------------------------------------------|
//|ExtFiboDinamic - ��������� ����� ����������� ������� ����.            |
//|                 ������������ ������ ���� ��������� �� ������ ����    |
//|                 ZigZag-a.                                            |
//|                                                                      |
//|ExtFiboStatic - ��������� ����� ����������� ������� ����              |
//|                                                                      |
//|ExtFiboStaticNum - ����� ���� ZigZag-a, �� ������� ����� ����������   |
//|                   ����������� ������ ���������. 1<ExtFiboStaticNum<=9|
//|                                                                      |
//|ExtFiboType =  0 - ����������� ����                                   |
//|               1 - ���� � ������� ��������� � �.�.                    |
//|               3 - ����, �������� �������������                       |
//|                                                                      |
//|ExtFiboTypeFree - ������� ���������������� ���                        |
//|                                                                      |
//|ExtFiboCorrectionExpansion = false - ��������� ���������              |
//|                           = true  - ���������� ���������             |
//|                                                                      |
//|ExtFiboD � ExtFiboS - ����� ����� ������������ � ����������� ���.     |
//|----------------------------------------------------------------------|
//|                                                                      |
//|               "Parameters for Pesavento Patterns"                    |
//|                                                                      |
//|----------------------------------------------------------------------|
//|ExtPPWithBars - ��������� �������������� ���������� ����� ��������    |
//|                ������������ ��������� ���������.                     |
//|                                                                      |
//|             0 - ��������� ����������� ��� ���� �����                 |
//|             1 - ��������� ���������� ����� ����� �������, ���������� |
//|                 "������������" (��������� ���������)                 |
//|             2 - ��������� ���������� ����� ��� ������� � �������     |
//|                 ��������� ���� �������, ����� �������� ��������      |
//|                 "����������" (��������� ���������)                   |
//|             3 - ��������� ��������� ���������� ����� ��������        |
//|                 �����������. ��������� ���������� �������������� ��� |
//|                 ��������� ���������� ����� �� ������ ���� ������� �  |
//|                 ���������� ����� �� ������ ���� �������              |
//|             4 - ��������� ��������� ����������, ������������ ���     |
//|                 ��������� ������� �������� ������� ���� � �������    |
//|                 �������� ������� ����                                |
//|                                                                      |
//|             6 - ������� ���������� ������� � ���������, �� �������   |
//|                 ������� ���� �������� ������� ���������� ��          |
//|                 ����� ���������                                      |
//|                                                                      |
//|             7 - ������� �������� �������� ��� ������� � ������� �����|
//|                 ������ �������� ����� ����� ������������ ��� ������- |
//|                 ����� �������� ��������. ������ �������� ������������|
//|                 ��� �������������� ��������������� ���� ���.         |
//|                                                                      |
//|ExtHidden - 0 - ����� � ����� ��������� ��������� ������.             |
//|            1 - ���������� ��� ����� ����� ����������, � �������      |
//|                ������� �������������� >0.14 � <5.                    |
//|            2 - ���������� ������ ��  �����, ��� ������� ��������-    |
//|                ������ ����� ������ ��������� (� 0.447, 0.886, 2.236, |
//|                3.14, 3,618 ��� ���������� ��������� Gartley)         |
//|            3 - ���������� �����, ������������� � ������ 2            |
//|                � ��������������� �����                               |
//|            4 - ���������� ����� �� ��������� � ��������������� ����� |
//|            5 - �������� ��� ��������. �������� ������ ZigZag         |
//|                                                                      |
//|ExtFractal - ���������� ��������� (����������, ���������),            |
//|             �� ������� ���� ����� � ������ ���������                 |
//|                                                                      |
//|ExtFractalEnd - ���������� ���������, � ������� ���� �����            |
//|                ������ ����� �������� ����������� ����� �� �����      |
//|                ���� ExtFractalEnd=0 �� ��������� ������� �����       |
//|                ������������� ����� ���������.                        |
//|                ����������� �������� ExtFractalEnd=1                  |
//|                                                                      |
//|ExtFiboChoice - ����� ������ ����� ����� ��� ���������� ���������     |
//|                ���������. �������� �������� ������� �� 0 �� 11       |
//|                                                                      |
//|ExtFiboZigZag - ��������� ����� "ZiaZag Fibonacci"                    |
//|                                                                      |
//|ExtDelta - (������) ���������� � �������. ������ ��������             |
//|           ������������� ����������� ����.                            |
//|                  ������ ���� 0<ExtDelta<1                            |
//|                                                                      |
//|ExtDeltaType -    0 - ��������� �������� �������������� "��� ����"    |
//|                      � ����������� �� 2 ���� ����� �������           |
//|                  1 - ������ ������� (%-����� ���������)<ExtDelta     |
//|                  2 - ((%-����� ���������)/����� ���������)<ExtDelta  |
//|                  3 - ��������� �������� �������������� "��� ����"    |
//|                      � ����������� �� 3 ���� ����� �������           |
//|                                                                      |
//|ExtSizeTxt - ������ ������ ��� ������ �����                           |
//|                                                                      |
//|ExtLine - ����� ����� �������������� �����                            |
//|                                                ������������          |
//|ExtLine886 - ����� ����� �������������� ����� � ������� ���������     |
//|                                                ������������          |
//|ExtNotFibo - ����� ����� ���� ��������� �����                         |
//|                                                                      |
//|ExtPesavento - ����� ����� ����� ���������                            |
//|                                                                      |
//|ExtGartley886 - ����� ����� ����� .886 � ������ ��������������        |
//|----------------------------------------------------------------------|
//|                                                                      |
//|               "Parameters for Gartley Patterns"                      |
//|                                                                      |
//|----------------------------------------------------------------------|
//|maxDepth - ������������ �������� Depth (minBars), �� �������� �����   |
//|           ���������� �������� Depth ������� ��� �������� ������������|
//|           ��� ������ ��������� Gartley                               |
//|minDepth - ������ ����������� �������� Depth ��� ������ ���������     |
//|           Gartley.                                                   |
//|                                                                      |
//|DirectionOfSearchMaxMin - ������ ����������� ������:                  |
//|           false - �� minDepth � maxDepth                             |
//|           true - �� maxDepth � minDepth                              |
//|                                                                      |
//|ExtGartleyOnOff - �������� ����� ��������� Gartley.                   |
//|                                                                      |
//|maxBarToD - ������ ������������ ���������� ����� �� ��������          |
//|            �� ����� D ��������                                       |
//|                                                                      |
//|RangeForPointD - ��������� ����� ���� �������� ����� D                |
//|                                                                      |
//|ExtColorRangeForPointD - ���� ����� ���� �������� ����� D             |
//|                                                                      |
//|ExtDeltaGartley - ������ �� ���������� ���� ��� ������ ���������      |
//|                  �� ��������� 9% - 0.09                              |
//|                                                                      |
//|ExtColorPatterns - ���� ������������� ���������                       |
//|                                                                      |
//|ExtCD - �������� ���� CD �������� ������������ ���� BC ����� �������  |
//|        ���������� ����� ��������� (�������� - ��� ������ ��������)   |
//|----------------------------------------------------------------------|
//|                                                                      |
//|               "Parameters for Andrews Pitchfork"                     |
//|                                                                      |
//|----------------------------------------------------------------------|
//|ExtPitchforkDinamic > 0 (=1) ��������� ������������ ���� ������� ��   |
//|             ��������� ���� ����������� ZigZag                        |
//|             =2 50% �������                                           |
//|             =3 50% ����                                              |
//|             =4 ����� �����                                           |
//|                                                                      |
//|ExtPitchforkStatic > 0 (=1) ��������� ����������� ���� ������� ��     |
//|             ���������� ZigZag � ������� ExtPitchforkStaticNum        |
//|             =2 50% �������                                           |
//|             =3 50% ����                                              |
//|             =4 ����� �����                                           |
//|                                                                      |
//|3<ExtPitchforkStaticNum<=9 - ����� ������� ZigZag, �� �������         |
//|           ���������� ����������� ����                                |
//|                                                                      |
//|ExtLinePitchforkD �                                                   | 
//|ExtLinePitchforkS ������ ���� ������������ � ����������� ���          |
//|                                                                      |
//|ExtPitchforkStaticColor - ������ ���� �������� ������ ���             |
//|                                                                      |
//|ExtPitchforkStyle - ������ ����� ������ ���.                          |
//|             0 - �������� �����                                       |
//|             1 - ��������� �����                                      |
//|             2 - ���������� �����                                     |
//|             3 - �����-���������� �����                               |
//|             4 - �����-���������� ����� � �������� �������            |
//|             5-10 - ������ ������� �������� �����                     |
//|                                                                      |
//|ExtFiboFanDinamic - ��������� ����� ������������ ����-������          |
//|                                                                      |
//|ExtFiboFanStatic - ��������� ����� ����������� ����-������            |
//|                   ��������� ������ �� ������������ ������            |
//|                                                                      |
//|ExtFiboFanD - ������ ���� ������������ ����-������                    |
//|                                                                      |
//|ExtFiboFanS - ������ ���� ����������� ����-������                     |
//|                                                                      |
//|ExtFiboFanExp - ���������� ����� ���� �����. true=6, false=4          |
//|                                                                      |
//|ExtFiboFanHidden - ��������� ����� ���������� ����� ����-������       |
//|                                                                      |
//|ExtFiboFanMedianaDinamicColor �                                       |
//|ExtFiboFanMedianaStaticColor - ������ ���� ����-������ ��             |
//|    ��������� ����� ������������ � ����������� ���                    |
//|                                                                      |
//|   ��������� ���� ���� ��������� ������ ��� ����������� ���           |
//|ExtFiboTime1 - �������� ��������� ���� ���� 1.                        |
//|                                                                      |
//|ExtFiboTime2 - �������� ��������� ���� ���� 2.                        |
//|                                                                      |
//|ExtFiboTime1C - ������ ���� ����� ��������� ���� 1.                   |
//|                                                                      |
//|ExtFiboTime2C - ������ ���� ����� ��������� ���� 2.                   |
//|                                                                      |
//|ExtPivotZoneDinamicColor - ������ ���� �������� �������. Pivot Zone   |
//|                                                                      |
//|ExtPivotZoneStaticColor - ������ ���� �������� ������. Pivot Zone     |
//|                                                                      |
//|ExtPivotZoneFramework - ����� Pivot Zone � ���� ����� (�� ���������)  |
//|                        ��� � ���� ������������ ��������������        |
//|                                                                      |
//|ExtUTL - �������� ������� ����������� ����� ��� �������               |
//|                                                                      |
//|ExtLTL - �������� ������ ����������� ����� ��� �������                |
//|                                                                      |
//|ExtUWL - �������� ������� ��������������� �����                       |
//|                                                                      |
//|ExtLWL - �������� ������ ��������������� �����                        |
//|                                                                      |
//|ExtISLDinamic - �������� ���������� ���������� �����                  |
//|                ��� ������������ ��� �������                          |
//|ExtISLStatic  - �������� ���������� ���������� �����                  |
//|                ��� ����������� ��� �������                           |
//|                                                                      |
//|ExtRLine - ��������� ����� ����� ������� ����� ��� �������            |
//|                                                                      |
//|ExtRLineBase - �������� ������������ ����� �������                    |
//|                                                                      |
//|ExtPitchforkCandle - �������� ����� ��������� ��� �� ��������� ������ |
//|                                                                      |
//|ExtDateTimePitchfork_1, ExtDateTimePitchfork_2,                       |
//|                                                                      |
//|ExtDateTimePitchfork_3 - �������� ���� � ����� ������, �� �������     |
//|  ����� ��������� ���� �������                                        |
//|                                                                      |
//|ExtPitchfork_1_HighLow - ��� ���������� ��� �� ��������� ������ ��-   |
//|  ���� �� ��������� ��� �������� ����� ������� ������ ����� ���       |
//|----------------------------------------------------------------------|
//|                                                                      |
//|               "Parameters for micmed Channels"                       |
//|                                                                      |
//|----------------------------------------------------------------------|
//| ������ micmed'a �������� � ������� ��� �������                       |
//|                                                                      |
//|ExtCM_0_1A_2B_Static, ExtCM_0_1A_2B_Dinamic - ������ micmed'a.        |
//|                                          �������� ���������� �� 0-5  |
//|                                                                      |
//|ExtCM_FiboStatic, ExtCM_FiboDinamic - �������� ��������� ���������    |
//|                  ����� ��� ������� ��� ���������� ������� micmed'a   |
//|----------------------------------------------------------------------|
//|                                                                      |
//|               "Parameters for fibo Fan"                              |
//|                                                                      |
//|----------------------------------------------------------------------|
//|ExtFiboFanColor - �������� ������������ ��������� �������� �����.     |
//|                                                                      |
//|ExtFiboFanNum - ����� ���� ZigZag-a, �� ������� ����� ����������      |
//|                  ������������ ���������. 1<ExtFiboStaticNum<=9       |
//|----------------------------------------------------------------------|
//|                                                                      |
//|               "Parameters for fibo Expansion"                        |
//|                                                                      |
//|----------------------------------------------------------------------|
//|ExtFiboExpansion - ���������� ���������, ��� � ������������           |
//|                 < 2 ���������� ��������� �� ���������                |
//|                 = 2 ������������ ��������� ���������                 |
//|                 >2 � <=9 ����������� ���������� ���������            |
//|                                                                      |
//|ExtFiboExpansionColor - ������ ���� ����� ���������� ���������        |
//|----------------------------------------------------------------------|
//|                                                                      |
//|               "Parameters for versum Levels"                         |
//|                                                                      |
//|----------------------------------------------------------------------|
//|ExtVLDinamicColor - ������� Versum Levels ������������ ������� �����  |
//|                                                                      |
//|ExtVLStaticColor - �������� Versum Levels ����������� ������� �����   |
//|                                                                      |
//|ExtVLStaticNum - ������ ����� �������, �� ������� ���������           |
//|                 Versum Levels                                        |
//|----------------------------------------------------------------------|
//|                                                                      |
//|               "Parameters for fibo Arc"                              |
//|                                                                      |
//|----------------------------------------------------------------------|
//|ExtArcDinamicNum - ������ ����� ��������� ZigZag �� �������           |
//|                   �������� ������������ ���� ����                    |
//|                                                                      |
//|ExtArcStaticNum - ������ ����� ��������� ZigZag �� �������            |
//|                   �������� ����������� ���� ����                     |
//|                                                                      |
//|ExtArcDinamicColor - ������ ���� ������������ ���� ���                |
//|                                                                      |
//|ExtArcStaticColor - ������ ���� ����������� ���� ���                  |
//|                                                                      |
//|ExtArcDinamicScale - ������ ������� ������������ ���� ���             |
//|          0 - �����������; >0 - ������� �������� �������������        |
//|                                                                      |
//|ExtArcStaticScale ������ ������� ����������� ���� ���                 |
//|          0 - �����������; >0 - ������� �������� �������������        |
//|----------------------------------------------------------------------|
//|                                                                      |
//|               "Parameters Exp"                                       |
//|                                                                      |
//|----------------------------------------------------------------------|
//|chHL     = true     - ���� ������ ���������� ������ �������������     |
//|                                                                      |
//|PeakDet  = true     - ���� ������ ���������� ������ ����������        |
//|                      ����������                                      |
//|                                                                      |
//|chHL_PeakDet_or_vts - true - �� ��������� ��������� ����� �����       |
//| ������������� (������� �����) � ������ ���������� ���������� ZigZag. |
//|  false - ��������� ��������� i-vts.                                  |
//|                                                                      |
//|NumberOfBars - ���������� ����� ������� (0-���) ��� i-vts.            |
//|                                                                      |
//|NumberOfVTS - ���, � ��� �������, �������� ����������� ��� i-vts.     |
//|                                                                      |
//|NumberOfVTS1 - �������� ����������� ��� ������ ����� i-vts.           |
//|----------------------------------------------------------------------|
//|                                                                      |
//|               "Common Parameters"                                    |
//|                                                                      |
//|----------------------------------------------------------------------|
//|ExtObjectColor - ������ ���� �����, ����������� ������� ����� ��������|
//|                                                                      |
//|ExtObjectStyle - ������ c���� �����,                                  |
//|                                    ����������� ������� ����� ��������|
//|                                                                      |
//|ExtObjectWidth - ������ ������� �����,                                |
//|                                    ����������� ������� ����� ��������|
//|                                                                      |
//|ZigZagHighLow - ������, �� ����� ����� ������ ����������              |
//|                ��������� ���������, ��� ������� � �.�.               |
//|true - �� ����������� �����                                           |
//|false - �� ��������� ZigZag, ����� ��� ����� � "�������"              |
//|                                                                      |
//|ExtSendMail - �������� ��������� �� email � ����������� ��������.     |
//|                                                                      |
//|ExtAlert - ��������� ����� ��������� � ��������� ������� ���          |
//|           ������������� ������ ���� ZigZag                           |
//|                                                                      |
//|ExtBack - ������ ����� ���� �������� � ���� ����                      |
//|                                                                      |
//|ExtSave - ��������� ���������� ��������� ����������� ��� �            |
//|          Fibo Time                                                   |
//|                                                                      |
//|infoTF - �������� ���������� �� 5 ������� �����������.                |
//|         ��������� ������������ ����������. ������ ����� � �������.   |
//|         ������� ��������� ���� ������������ ��������.                |
//|         ����� ���������� ������ ���� ������� ���������� � ���������. |
//|         ���������� �������� ��������� Gartley � ������ ����          |
//|         ���������� �������� ����� D ��� ��������� Gartley.           |
//|                                                                      |
//|ExtComplekt - ������ ����� ����������. ��� ������ �� ������ ����������|
//|              ����������� ����� ���� �������� �������� ����� �����.   |
//|              ��� ���� ��� ����� ���������� ����� �������� ���������. |
//+----------------------------------------------------------------------+
#property copyright "nen"
#property link      "http://onix-trade.net/forum/index.php?s=&showtopic=118&view=findpost&p=214172"
// �������� http://onix-trade.net/forum/index.php?s=&showtopic=373&view=findpost&p=72865

#property stacksize 16384
#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 Magenta//Red 
//#property indicator_width1 2 
#property indicator_color2 Green
#property indicator_color3 Orange
#property indicator_color4 LightSkyBlue
#property indicator_color5 LemonChiffon
#property indicator_color6 Yellow
//===================================
//---- indicator parameters
extern string Var0___________________________ = "Parameters for ZigZag";
extern int    ExtIndicator  = 11;
extern int    minBars       = 8;
extern int    minSize       = 55;
// ���������� �� ZigZag �� ��
extern int    ExtDeviation  = 5;
extern int    ExtBackstep   = 3;
// ���������� ��� nen-ZigZag
extern int    GrossPeriod   = 1440;
//----
extern double minPercent    = 0;
extern int    ExtPoint=11; // ���������� ����� ������� ��� ������� Talex 
extern bool   ExtStyleZZ = true;
//----
extern string Var1___________________________ = "Parameters for fibo Levels";
extern bool   ExtFiboDinamic   = false;
extern bool   ExtFiboStatic    = false;
extern int    ExtFiboStaticNum = 2;
extern int    ExtFiboType      = 1;
extern string ExtFiboTypeFree  = "0,0.382,0.618,0.786,1,1.272,1.618";
extern bool   ExtFiboCorrectionExpansion = false;
extern color  ExtFiboD         = Sienna;
extern color  ExtFiboS         = Teal;
//-------------------------------------
extern string Var2___________________________ = "Parameters for Pesavento Patterns";
extern int    ExtPPWithBars = 0;
extern int    ExtHidden     = 1;
extern int    ExtFractal    = 7;
extern int    ExtFractalEnd = 7;
extern int    ExtFiboChoice    = 2;
extern bool   ExtFiboZigZag = false;
extern double ExtDelta      = 0.04;
extern int    ExtDeltaType  = 2;
extern int    ExtSizeTxt       = 7;
extern color  ExtLine          = DarkBlue;
extern color  ExtLine886       = Purple;
extern color  ExtNotFibo       = SlateGray;
extern color  ExtPesavento     = Yellow;
extern color  ExtGartley886    = GreenYellow;
       color  colorPPattern;
// �������� Gartley
extern string Var3___________________________ = "Parameters for Gartley Patterns";
extern int    maxDepth                = 33;
extern int    minDepth                = 3;
extern bool   DirectionOfSearchMaxMin = true;
extern bool   ExtGartleyOnOff         = false;
//extern int    VarDisplay=0;
extern int    maxBarToD               = 15;
extern bool   RangeForPointD          = true;
extern color  ExtColorRangeForPointD  = Red;
extern double ExtDeltaGartley         = 0.09;
extern color  ExtColorPatterns        = Blue;
extern double ExtCD                   = 0.886;
//----------------------------------------------------------------------
// �������� ������������, ���������� ��������� � ������ �������. ������.
//----------------------------------------------------------------------
// ���������� ��� ��� �������
extern string Var4___________________________ = "Parameters for Andrews Pitchfork";
extern int    ExtPitchforkDinamic     = 0;
extern int    ExtPitchforkStatic      = 0;
extern int    ExtPitchforkStaticNum   = 3;
extern color  ExtLinePitchforkD       = MediumSlateBlue;
extern color  ExtLinePitchforkS       = MediumBlue;
extern color  ExtPitchforkStaticColor = CLR_NONE;
extern int    ExtPitchforkStyle       = 1;
// ���������� ��� ����������
extern bool   ExtFiboFanDinamic = false;  // ����� ���������� ��������������
extern bool   ExtFiboFanStatic  = false;  // ��������� ������ ��������� �� ������������ ������
extern bool   ExtFiboFanExp     = true;
extern bool   ExtFiboFanHidden  = false;
extern color  ExtFiboFanD       = Sienna;
extern color  ExtFiboFanS       = Teal;

extern color  ExtFiboFanMedianaDinamicColor = CLR_NONE;
extern color  ExtFiboFanMedianaStaticColor  = CLR_NONE;

// ��������� ���� ����
extern bool   ExtFiboTime1      = false;
extern bool   ExtFiboTime2      = false;
extern color  ExtFiboTime1C     = Teal;
extern color  ExtFiboTime2C     = Sienna;

// Pivot Zone
extern color  ExtPivotZoneDinamicColor = CLR_NONE;
extern color  ExtPivotZoneStaticColor = CLR_NONE;
extern bool   ExtPivotZoneFramework   = false;

// ��������� ��������������� � ����������� �����
extern bool   ExtUTL = false;
extern bool   ExtLTL = false;
extern bool   ExtUWL = false;
extern bool   ExtLWL = false;
extern bool   ExtISLDinamic = false;
extern bool   ExtISLStatic  = false;

// ��������� ����� �������
extern bool   ExtRLine     = true;
extern bool   ExtRLineBase = true;
//----------------------------------------------------------------------
//extern bool     ExtPitchforkCandle = false;
//extern bool     ExtPitchfork_1_HighLow = false;
//extern datetime ExtDateTimePitchfork_1 = D'11.07.2006 00:00';
//extern datetime ExtDateTimePitchfork_2 = D'19.07.2006 00:00';
//extern datetime ExtDateTimePitchfork_3 = D'09.08.2006 00:00';
//----------------------------------------------------------------------
// ���� ������� ��������� ��������� ��� ���������� ��� ������� ��� ���� ������� eurusd ��� ������
//----------------------------------------------------------------------
extern bool     ExtPitchforkCandle     = false;
extern datetime ExtDateTimePitchfork_1 = D'15.06.1989 00:00';
extern datetime ExtDateTimePitchfork_2 = D'08.03.1995 00:00';
extern datetime ExtDateTimePitchfork_3 = D'26.10.2000 00:00';
extern bool     ExtPitchfork_1_HighLow = false;
//----------------------------------------------------------------------
// ������ micmed'a
extern string Var5___________________________ = "Parameters for micmed Channels";
extern int     ExtCM_0_1A_2B_Dinamic = 0, ExtCM_0_1A_2B_Static = 0;
extern double  ExtCM_FiboDinamic = 0.618, ExtCM_FiboStatic = 0.618;
//----------------------------------------------------------------------
// �������� ������������, ���������� ��������� � ������ �������. �����.
//----------------------------------------------------------------------
// ��������� ��������������
extern string Var6___________________________ = "Parameters for fibo Fan";
extern color  ExtFiboFanColor = CLR_NONE;
extern int    ExtFiboFanNum = 0;
// ���������� ���������
extern string Var7___________________________ = "Parameters for fibo Expansion";
extern int    ExtFiboExpansion = 0;
extern color  ExtFiboExpansionColor = Yellow;
//--------------------------------------
extern string Var8___________________________ = "Parameters for versum Levels";
extern color  ExtVLDinamicColor = CLR_NONE;
extern color  ExtVLStaticColor = CLR_NONE;
extern int    ExtVLStaticNum = 0;
//--------------------------------------
extern string Var9___________________________ = "Parameters for fibo Arc";
extern int ExtArcDinamicNum     = 0;
extern int ExtArcStaticNum      = 0;
extern color ExtArcDinamicColor = Sienna;
extern color ExtArcStaticColor  = Teal;
extern double ExtArcDinamicScale= 0;
extern double ExtArcStaticScale = 0;
//extern int ExtArcStyle          = 0;
//extern int ExtArcWidth          = 1;
extern string Var10__________________________ = "Parameters Exp";
extern bool   chHL = false;
extern bool   PeakDet = false;
// ���������� ��� i-vts
extern bool   chHL_PeakDet_or_vts = true;
extern int    NumberOfBars = 1000;     // ���������� ����� ������� (0-���)
extern int    NumberOfVTS  = 13;
extern int    NumberOfVTS1 = 1;
extern string Var11__________________________ = "Common Parameters";
//--------------------------------------
extern color  ExtObjectColor   = CLR_NONE;
extern int    ExtObjectStyle   = 1;
extern int    ExtObjectWidth   = 0; 
extern bool   ZigZagHighLow    = true;
// --------------------------------
// �������������� �������
extern bool   ExtSendMail = false;
extern bool   ExtAlert = false;
// ����� �������� � ���� ����
extern bool   ExtBack = true;
// ���������� ����������� ��� �������, Fibo Time � �.�.
extern bool   ExtSave = false;
extern bool   infoTF = false;
extern int    ExtComplekt=0;
//===================================

// ������� ��� ZigZag 
// ������ ��� ��������� ZigZag
double zz[];
// ������ ��������� ZigZag
double zzL[];
// ������ ���������� ZigZag
double zzH[];
// ������� ��� nen-ZigZag
double nen_ZigZag[];
// ������ ��� ����������������� ZigZag
//double TempBuffer[1],ZigZagBuffer[1];
// ���������� ��� ��������
// ������ ����� ��������� (���� � ���������������� ����)
//double fi[]={0.146, 0.236, 0.382, 0.447, 0.5, 0.618, 0.707, 0.786, 0.841, 0.886, 1.0, 1.128, 1.272, 1.414, 1.5, 1.618, 1.732, 1.902, 2.0, 2.236, 2.414, 2.618, 3.14, 3.618, 4.0};
//string fitxt[]={"0.146", "0.236", ".382", ".447", ".5", ".618", ".707", ".786", ".841", ".886", "1.0", "1.128", "1.272", "1.414", "1.5", "1.618", "1.732", "1.902", "2.0", "2.236", "2.414", "2.618", "3.14", "3.618", "4.0"};
//double fi1[]={0.146, 0.236, 0.382, 0.5, 0.618, 0.764, 0.854, 1.0, 1.236, 1.618};
//string fitxt1[]={"0.146", "0.236", ".382", ".5", ".618", ".764", ".854", "1.0", "1.236", "1.618"};
// ������ �����, �������� �������������
double fi[];
string fitxt[];
string fitxt100[];
int    Sizefi=0,Sizefi_1=0;

color ExtLine_;

int minBarsSave, minBarsX;

double number[64];
string numbertxt[64];
int    numberFibo[64];
int    numberPesavento[64];
int    numberGartley[64];
int    numberMix[64];
int    numberGilmorQuality[64];
int    numberGilmorGeometric[64];
int    numberGilmorHarmonic[64];
int    numberGilmorArithmetic[64];
int    numberGilmorGoldenMean[64];
int    numberSquare[64];
int    numberCube[64];
int    numberRectangle[64];
int    numberExt[64];

string nameObj,nameObjtxt,save;
// 
bool descript_b=false;
// PPWithBars - �����, ��������� � �������������� �����
// descript - �������� ��������
string PPWithBars, descript;
// ������� ��� ������ ����������� ����� afr - ������ �������� ������� ���� ��������� ��������� � ��������� ������������ � ����������� ���
// afrl - ��������, afrh - ���������
int afr[]={0,0,0,0,0,0,0,0,0,0};
double afrl[]={0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0}, afrh[]={0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0}, afrx[]={0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0};
// ��������� ����������
double openTF[]={0.0,0.0,0.0,0.0,0.0}, closeTF[]={0.0,0.0,0.0,0.0,0.0}, lowTF[]={0.0,0.0,0.0,0.0,0.0}, highTF[]={0.0,0.0,0.0,0.0,0.0};
double close_TF=0;
string TF[]={"MN","W1","D1","H4","H1","m30","m15","m5","m1"};
string Period_tf;
bool afrm=true;
double ExtHL;
double HL,HLp,kk,kj,Angle;
// LowPrim,HighPrim,LowLast,HighLast - �������� ��������� � ���������� �����
double LowPrim,HighPrim,LowLast,HighLast;
// numLowPrim,numHighPrim,numLowLast,numHighLast -������ �����
int numLowPrim,numHighPrim,numLowLast,numHighLast,k,k1,k2,ki,kiPRZ=0,countLow1,countHigh1,shift,shift1;
string txtkk;
// ����� ����� � ������ �� �������� ���� ���������
int timeFr1new;
// ������� ���������
int countFr;
// ���, �� �������� ���� �������� �������������� ����� �� �������� ����
int countBarEnd=0,TimeBarEnd;
// ���, �� �������� ���� ������������� �� �������� ����
int numBar=0;
// ����� �������
int numOb;
// flagFrNew=true - ����������� ����� ������� ��� ������ ������� ��������� �� ������ ���. =false - �� ���������.
bool flagFrNew=false;
// flagGartle - ��������� ������ �������� Gartley ��� ������������ �������� Gartley
bool flagGartle=false;
// ������ �������� �������
int perTF;
bool Demo;

double int_to_d=0, int_to_d1=0, int_to_d2=0;

int counted_bars, cbi, iBar;

// ������� ������ ���� �������� ����������
// The average size of a bar
double ASBar;

// ���������� ��� ZigZag ������ � ���������� ��������� ����������� � Ensign
double ha[],la[],hi,li,si,sip,di,hm,lm,ham[],lam[],him,lim,lLast=0,hLast=0;
int fs=0,fsp,countBar;
int ai,aip,bi,bip,ai0,aip0,bi0,bip0;
datetime tai,tbi,taip,tbip,ti;
// fcount0 - ��� ��������� �������� ����������� ����� �� 0 ���� fcount0=true.
// �� ��������� ���� =false � ����� ���������� ����� ��������
bool fh=false,fl=false,fcount0;

// ���������� ��� ������� �����
double lLast_m=0, hLast_m=0;
int countBarExt; // ������� ������� �����
int countBarl,countBarh;

// ���������� ��� nen-ZigZag
bool hi_nen;
bool init_zz=true;

// ���������� ��� ������������ ������ ������ ����������
int mFibo[]={0,0}, mPitch[]={0,0,0}, mFan[]={0,0}, mExpansion[]={0,0,0}, mVL[]={0,0,0}, mArcS[]={0,0}, mArcD[]={0,0};
// ���������� ��� ���������� ��� ������� �� ������
int mPitchTime[]={0,0,0};
int mPitchTimeSave;
double mPitchCena[]={0.0,0.0,0.0};

// ���������� ��� vts
double ms[2];
// ���������� ��� ��������� Gartley
string   vBullBear    = ""; // ���������� ��� ����������� ����� ��� �������� �������
string   vNamePattern = ""; // ���������� ��� ����������� ������������ ��������
int maxPeak, vPatOnOff, vPatNew=0;
double hBar, lBar;
datetime tiZZ; 
bool     FlagForD  = true;  // ���������� �� ����� ������� ����������� ����� D �������� (Gartley)
datetime TimeForDmin  = 0;
datetime TimeForDmax  = 0;
double   LevelForDmin = 0;
double   LevelForDmax = 0;
// ���������� ��� ������� Talex
static int    endbar = 0;
static double endpr  = 0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string aa,aa1;
   int aa2, i;

   minBarsSave=minBars;

   IndicatorBuffers(8);

   if (ExtStyleZZ) {SetIndexStyle(0,DRAW_SECTION);}
   else {SetIndexStyle(0,DRAW_ARROW); SetIndexArrow(0,159);}
   SetIndexLabel(0,"ZUP"+ExtComplekt+" (zz"+ExtIndicator+")");
   if (ExtIndicator==6) SetIndexLabel(5,"ZUP"+ExtComplekt+" DT6_"+minBars+"/"+ExtDeviation+"/"+ExtBackstep+"/GP"+GrossPeriod+"");
   else if (ExtIndicator==7) SetIndexLabel(5,"ZUP"+ExtComplekt+" DT7_"+minBars+"/GP"+GrossPeriod+"");
   else if (ExtIndicator==8) SetIndexLabel(5,"ZUP"+ExtComplekt+" DT8_"+minBars+"/"+ExtDeviation+"/GP"+GrossPeriod+"");
   if (chHL_PeakDet_or_vts)
     {
      SetIndexLabel(1,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" H_PeakDet");
      SetIndexLabel(2,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" L_PeakDet");
      SetIndexLabel(3,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" H_chHL");
      SetIndexLabel(4,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" L_chHL");
     }
   else
     {
      SetIndexLabel(1,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" H_vts");
      SetIndexLabel(2,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" L_vts");
      SetIndexLabel(3,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" H_vts1");
      SetIndexLabel(4,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" L_vts1");
     }

   SetIndexBuffer(0,zz);
   SetIndexBuffer(5,nen_ZigZag);
   SetIndexBuffer(6,zzL);
   SetIndexBuffer(7,zzH);

   SetIndexStyle(5,DRAW_ARROW);
   SetIndexArrow(5,159);
// ������ ���������� �����
   SetIndexStyle(1,DRAW_LINE,STYLE_DOT);
   SetIndexStyle(2,DRAW_LINE,STYLE_DOT); 
   SetIndexBuffer(1,ham);
   SetIndexBuffer(2,lam);
// ������ �������������
   SetIndexStyle(3,DRAW_LINE,STYLE_DOT);
   SetIndexStyle(4,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(3,ha);
   SetIndexBuffer(4,la);

   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexEmptyValue(2,0.0);
   SetIndexEmptyValue(3,0.0);
   SetIndexEmptyValue(4,0.0);
   SetIndexEmptyValue(5,0.0);
   SetIndexEmptyValue(6,0.0);
   SetIndexEmptyValue(7,0.0);

   if (ExtIndicator<6 || ExtIndicator>10)
     {
      switch (Period())
        {
         case 1     : {Period_tf=TF[8];break;}
         case 5     : {Period_tf=TF[7];break;}
         case 15    : {Period_tf=TF[6];break;}
         case 30    : {Period_tf=TF[5];break;}
         case 60    : {Period_tf=TF[4];break;}
         case 240   : {Period_tf=TF[3];break;}
         case 1440  : {Period_tf=TF[2];break;}
         case 10080 : {Period_tf=TF[1];break;}
         case 43200 : {Period_tf=TF[0];break;}
        }
     }
   else
      switch (GrossPeriod)
        {
         case 1     : {Period_tf=TF[8];break;}
         case 5     : {Period_tf=TF[7];break;}
         case 15    : {Period_tf=TF[6];break;}
         case 30    : {Period_tf=TF[5];break;}
         case 60    : {Period_tf=TF[4];break;}
         case 240   : {Period_tf=TF[3];break;}
         case 1440  : {Period_tf=TF[2];break;}
         case 10080 : {Period_tf=TF[1];break;}
         case 43200 : {Period_tf=TF[0];break;}
        }

   if (ExtIndicator==1) if (minSize!=0) di=minSize*Point/2;
   if (ExtIndicator==2) {di=minSize*Point; countBar=minBars;}
   if (ExtIndicator==3) {countBar=minBars;}

   if (ExtIndicator>5 && ExtIndicator<11 && GrossPeriod>Period())
     {
      if (GrossPeriod==43200 && Period()==10080) maxBarToD=maxBarToD*5; else maxBarToD=maxBarToD*GrossPeriod/Period();
     }
   
   if (ExtIndicator<6 ||ExtIndicator>10) GrossPeriod=Period();

   if (ExtFiboType<0) ExtFiboType=0;
   if (ExtFiboType>2) ExtFiboType=2;

   if (ExtFiboType==2) 
     {
      i=-1;
      aa2=0;
      while (aa2>=0)
        {
         aa2=StringFind(ExtFiboTypeFree, ",",i+1);
         if (aa2>=0)
           {i=aa2;Sizefi++;}
         else
           {
            if (StringLen(ExtFiboTypeFree)-i>0)
              {
               if (StrToDouble(StringSubstr(ExtFiboTypeFree,i+1))>0) Sizefi++;
               arrResize(Sizefi);
               aa1=ExtFiboTypeFree;
               for (i=0;i<Sizefi;i++)
                 {
                  aa2=StringFind(aa1, ",", 0);

                  fitxt[i]=StringTrimLeft(StringTrimRight(StringSubstr(aa1,0,aa2)));
                  fi[i]=StrToDouble(fitxt[i]);
                  if (fi[i]<1) fitxt[i]=StringSubstr(fitxt[i],1);
                  fitxt100[i]=DoubleToStr(100*fi[i],1);

                  if (aa2>=0) aa1=StringSubstr(aa1,aa2+1);
                 }
              }
           }
        }
     }
 
// �������� ������������ ��������� ������� ����������
   if (ExtDelta<=0) ExtDelta=0.001;
   if (ExtDelta>1) ExtDelta=0.999;

   if (ExtHidden<0) ExtHidden=0;
   if (ExtHidden>5) ExtHidden=5;
 
   if (ExtDeltaType<0) ExtDeltaType=0;
   if (ExtDeltaType>3) ExtDeltaType=3;

   if (ExtFiboChoice<0) ExtFiboChoice=0;
   if (ExtFiboChoice>11) ExtFiboChoice=11;

   if (ExtFractalEnd>0)
     {
      if (ExtFractalEnd<1) ExtFractalEnd=1;
     }

   if (ExtPitchforkStatic>4) ExtPitchforkStatic=4;
   if (ExtPitchforkDinamic>4) ExtPitchforkDinamic=4;

   if (ExtCM_0_1A_2B_Dinamic<0) ExtCM_0_1A_2B_Dinamic=0;
   if (ExtCM_0_1A_2B_Dinamic>5) ExtCM_0_1A_2B_Dinamic=5;
   if (ExtCM_0_1A_2B_Static<0) ExtCM_0_1A_2B_Static=0;
   if (ExtCM_0_1A_2B_Static>5) ExtCM_0_1A_2B_Static=5;
   if (ExtCM_FiboDinamic<0) ExtCM_FiboDinamic=0;
   if (ExtCM_FiboDinamic>1) ExtCM_FiboDinamic=1;
   if (ExtCM_FiboStatic<0) ExtCM_FiboStatic=0;
   if (ExtCM_FiboStatic>1) ExtCM_FiboStatic=1;

//--------------------------------------------
   if (ExtPitchforkStaticNum<3) ExtPitchforkStaticNum=3;
   
   if (ExtFiboStaticNum<2) ExtFiboStaticNum=2;

   if (ExtFiboStaticNum>9)
     {
      aa=DoubleToStr(ExtFiboStaticNum,0);
      aa1=StringSubstr(aa,0,1);
      mFibo[0]=StrToInteger(aa1);
      aa1=StringSubstr(aa,1,1);
      mFibo[1]=StrToInteger(aa1);
     }
   else
     {
      mFibo[0]=ExtFiboStaticNum;
      mFibo[1]=ExtFiboStaticNum-1;
     }

   if (ExtFiboFanNum<1) ExtFiboFanNum=1;

   if (ExtFiboFanNum>9)
     {
      aa=DoubleToStr(ExtFiboFanNum,0);
      aa1=StringSubstr(aa,0,1);
      mFan[0]=StrToInteger(aa1);
      aa1=StringSubstr(aa,1,1);
      mFan[1]=StrToInteger(aa1);
     }
   else
     {
      mFan[0]=ExtFiboFanNum;
      mFan[1]=ExtFiboFanNum-1;
     }

   if (ExtPitchforkStaticNum>99)
     {
      aa=DoubleToStr(ExtPitchforkStaticNum,0);
      aa1=StringSubstr(aa,0,1);
      mPitch[0]=StrToInteger(aa1);
      aa1=StringSubstr(aa,1,1);
      mPitch[1]=StrToInteger(aa1);
      aa1=StringSubstr(aa,2,1);
      mPitch[2]=StrToInteger(aa1);
     }
   else
     {
      mPitch[0]=ExtPitchforkStaticNum;
      mPitch[1]=ExtPitchforkStaticNum-1;
      mPitch[2]=ExtPitchforkStaticNum-2;
     }

   if (ExtFiboExpansion<2) ExtFiboExpansion=0;
   
   if (ExtFiboExpansion>0)
     {
      if (ExtFiboExpansion>99)
        {
         aa=DoubleToStr(ExtFiboExpansion,0);
         aa1=StringSubstr(aa,0,1);
         mExpansion[0]=StrToInteger(aa1);
         aa1=StringSubstr(aa,1,1);
         mExpansion[1]=StrToInteger(aa1);
         aa1=StringSubstr(aa,2,1);
         mExpansion[2]=StrToInteger(aa1);
        }
      else
        {
         mExpansion[0]=ExtFiboExpansion;
         mExpansion[1]=ExtFiboExpansion-1;
         mExpansion[2]=ExtFiboExpansion-2;
        }
     }
   
   if (ExtPitchforkCandle)
     {
      mPitchTime[0]=ExtDateTimePitchfork_1;
      mPitchTime[1]=ExtDateTimePitchfork_2;
      mPitchTime[2]=ExtDateTimePitchfork_3;

      if (ExtPitchfork_1_HighLow)
        {
         mPitchCena[0]=High[iBarShift(Symbol(),Period(),ExtDateTimePitchfork_1,true)];
         mPitchCena[1]=Low[iBarShift(Symbol(),Period(),ExtDateTimePitchfork_2,true)];
         mPitchCena[2]=High[iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3,true)];
        }
      else
        {
         mPitchCena[0]=Low[iBarShift(Symbol(),Period(),ExtDateTimePitchfork_1,true)];
         mPitchCena[1]=High[iBarShift(Symbol(),Period(),ExtDateTimePitchfork_2,true)];
         mPitchCena[2]=Low[iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3,true)];
        }

      if (mPitchCena[0]<=0 || mPitchCena[1]<=0 || mPitchCena[2]<=0) {ExtPitchforkCandle=false;ExtPitchforkStatic=0;}
     }

   if (ExtVLStaticNum>0)
     {
      if (ExtVLStaticNum<2) ExtVLStaticNum=2;

      if (ExtVLStaticNum>99)
        {
         aa=DoubleToStr(ExtVLStaticNum,0);
         aa1=StringSubstr(aa,0,1);
         mVL[0]=StrToInteger(aa1);
         aa1=StringSubstr(aa,1,1);
         mVL[1]=StrToInteger(aa1);
         aa1=StringSubstr(aa,2,1);
         mVL[2]=StrToInteger(aa1);
        }
      else
        {
         mVL[0]=ExtVLStaticNum;
         mVL[1]=ExtVLStaticNum-1;
         mVL[2]=ExtVLStaticNum-2;
        }
     }

   if (ExtArcStaticNum>0)
     {
      if (ExtArcStaticNum<2) ExtArcStaticNum=2;
      if (ExtArcStaticNum<12 && ExtArcStaticNum>9) ExtArcStaticNum=9;

      if (ExtArcStaticNum>=12)
        {
         aa=DoubleToStr(ExtArcStaticNum,0);
         aa1=StringSubstr(aa,1,1);
         mArcS[0]=StrToInteger(aa1);
         aa1=StringSubstr(aa,0,1);
         mArcS[1]=StrToInteger(aa1);
         if (mArcS[0]==0) {ExtArcStaticNum=0; mArcS[1]=0;}
        }
      else
        {
         mArcS[1]=ExtArcStaticNum;
         mArcS[0]=ExtArcStaticNum-1;
        }
     }

   if (ExtArcDinamicNum>0)
     {
      if (ExtArcDinamicNum>90) ExtArcStaticNum=90;

      if (ExtArcDinamicNum>9)
        {
         aa=DoubleToStr(ExtArcDinamicNum,0);
         aa1=StringSubstr(aa,1,1);
         mArcD[0]=StrToInteger(aa1);
         aa1=StringSubstr(aa,0,1);
         mArcD[1]=StrToInteger(aa1);
         if (mArcD[0]>0) mArcD[0]=0;
        }
      else
        {
         mArcD[1]=0;
         mArcD[0]=ExtArcDinamicNum;
        }
     }

   if (ExtSave)
     {
      MathSrand(LocalTime());
      save=MathRand();
     }

   if (ExtCM_0_1A_2B_Static==4 || ExtCM_0_1A_2B_Dinamic==4)
     {
      for (i=Bars-1; i>-1; i--)
        {
         ASBar=ASBar + iHigh(NULL,GrossPeriod,i) - iLow(NULL,GrossPeriod,i) + Point;
        }
      ASBar=ASBar/Bars;
     }
   
//   Comment("");
   array_();
   perTF=Period();
   Demo=IsDemo();
   delete_objects1();
   return(0);
  }
//+------------------------------------------------------------------+
//| ���������������. �������� ���� ��������� ����� � ��������� ��������
//+------------------------------------------------------------------+
int deinit()
  {
   int i;
   delete_objects_dinamic();
   delete_objects3();

   ObjectDelete("fiboS" + ExtComplekt+"_");
   ObjectDelete("fiboFanS" + ExtComplekt+"_");
   ObjectDelete("RLineS" + ExtComplekt+"_");
   ObjectDelete("pitchforkS" + ExtComplekt+"_");
   ObjectDelete("pmedianaS" + ExtComplekt+"_");
   ObjectDelete("1-2pmedianaS" + ExtComplekt+"_");
   ObjectDelete("fiboTime1" + ExtComplekt+"_");ObjectDelete("fiboTime2" + ExtComplekt+"_");
   ObjectDelete("UTL" + ExtComplekt+"_");ObjectDelete("LTL" + ExtComplekt+"_");
   ObjectDelete("UWL" + ExtComplekt+"_");ObjectDelete("LWL" + ExtComplekt+"_");
   ObjectDelete("ISL_S" + ExtComplekt+"_");
   ObjectDelete("CL" + ExtComplekt+"_");
   ObjectDelete("PivotZoneS" + ExtComplekt+"_");
   ObjectDelete("FanMedianaStatic" + ExtComplekt+"_");
   ObjectDelete("FiboFan" + ExtComplekt+"_");
   ObjectDelete("FiboArcS" + ExtComplekt+"_");
//   ObjectDelete("_"+ExtComplekt+"PointD");
   Comment("");
 
   for (i=0; i<7; i++)
     {
      nameObj="VLS"+i+" " + ExtComplekt+"_";
      ObjectDelete(nameObj);
     }
   return(0);
  }
//********************************************************

// ������
int start()
  {
   if ((ExtIndicator==6 || ExtIndicator==7 || ExtIndicator==8 || ExtIndicator==10) && Period()>GrossPeriod) 
     {
      for (iBar=Bars-1; iBar>0; iBar--) {zzL[iBar]=0.0; zzH[iBar]=0.0; zz[iBar]=0.0; nen_ZigZag[iBar]=0.0;}
      init_zz=true;
      return;
     }

   counted_bars=IndicatorCounted();
  
   if (perTF!=Period())
     {
      delete_objects1();  
      perTF=Period();
     }

   if (Demo!=IsDemo())
     {
      delete_objects1();  
      Demo=IsDemo();
      counted_bars=0;
     }

//-----------------------------------------
//
//     1.
//
// ���� ���������� �������. ������. 
//-----------------------------------------   
// zz[] - �����, ������ �� �������� ������� ��� ��������� ������ ZigZag-a
// zzL[] - ������ ��������� ��������
// zzH[] - ������ ���������� ��������
//
//-----------------------------------------   

if (Bars-IndicatorCounted()>2)
  {
   cbi=Bars-1; tiZZ=0;
   for (iBar=cbi; iBar>0; iBar--) {zzL[iBar]=0.0; zzH[iBar]=0.0; zz[iBar]=0.0; nen_ZigZag[iBar]=0.0;}
   init_zz=true; afrm=true; delete_objects_dinamic(); delete_objects3();
  }
else cbi=Bars-IndicatorCounted()+1;

if (lBar<=iLow(NULL,GrossPeriod,0) && hBar>=iHigh(NULL,GrossPeriod,0) && tiZZ==iTime(NULL,GrossPeriod,0)) return(0);
else
  {
   lBar=iLow(NULL,GrossPeriod,0); hBar=iHigh(NULL,GrossPeriod,0); tiZZ=iTime(NULL,GrossPeriod,0);

   switch (ExtIndicator)
     {
      case 0     : {ZigZag_();      break;}
      case 1     : {ang_AZZ_();     break;}
      case 2     : {Ensign_ZZ();    break;}
      case 3     : {Ensign_ZZ();    break;}
      case 4     : {ZigZag_tauber();break;}
      case 5     : {GannSwing();    break;}
      case 6     : {nenZigZag();    break;} // DT-ZigZag - � ������������, ���������������� �������� ZigZag_new_nen3.mq4
      case 7     : {nenZigZag();    break;} // DT-ZigZag - ������� �������, ������� ������� ����������� klot - DT_ZZ.mq4
      case 8     : {nenZigZag();    break;} // DT-ZigZag - ������� �������, ������� ������� ����������� Candid - CZigZag.mq4
      case 10    : {nenZigZag();    break;} // DT-ZigZag - ������� ������� ExtIndicator=5 � ������ DT - ������� ������ Swing_zz.mq4
// ����� ���������
      case 11    : 
       {
        ZigZag_();

        if (vPatOnOff==1 && vPatNew==0)
          {
           afrm=true; delete_objects_dinamic(); vPatNew=1; flagGartle=true; counted_bars=0; minBarsSave=minBarsX;
           if (ExtSendMail) _SendMail("There was a pattern","on  " + Symbol() + " " + Period() + " pattern " + vBullBear + " " + vNamePattern);
          }
        else if (vPatOnOff==0 && vPatNew==1)
          {
           afrm=true; delete_objects_dinamic(); vPatNew=0; flagGartle=true; counted_bars=0; FlagForD=true; minBarsSave=minBarsX;
          }
        else if (minBarsSave!=minBarsX)
          {
           afrm=true; delete_objects_dinamic(); vPatNew=1; flagGartle=true; counted_bars=0; minBarsSave=minBarsX;
          }
        break;
       } 

      case 12    : {ZZTalex(minBars);break;}
      case 13    : {ZigZag_SQZZ();break;}      
     }
  }

if (ExtHidden<5) // ���������� �� ����� ��������. ������.
  {
   if(!chHL_PeakDet_or_vts) {i_vts(); i_vts1();}
   // ������������� �������
   matriza();
   if (infoTF) if (close_TF!=Close[0]) info_TF();
  }


//-----------------------------------------
// ���� ���������� �������. �����.
//-----------------------------------------   

if (ExtHidden>0 && ExtHidden<5) // ���������� �� ����� ��������. ������.
  {
//======================
//======================
//======================

//-----------------------------------------
//
//     2.
//
// ���� ���������� ������. ������.
//-----------------------------------------   

   if (Bars - counted_bars>2 || flagFrNew)
     {

      // ����� ������� � ������ ����, �� �������� ����� ���������� �������������� ����� 
      if (countBarEnd==0)
        {
         if (ExtFractalEnd>0)
           {
            k=ExtFractalEnd;
            for (shift=0; shift<Bars && k>0; shift++) 
              { 
               if (zz[shift]>0 && zzH[shift]>0) {countBarEnd=shift; TimeBarEnd=Time[shift]; k--;}
              }
           }
         else 
           {
            countBarEnd=Bars-3;
            TimeBarEnd=Time[Bars-3];
           }
        }
      else
        {
         countBarEnd=iBarShift(Symbol(),Period(),TimeBarEnd); 
        }

     }
//-----------------------------------------
// ���� ���������� ������. �����.
//-----------------------------------------   


//-----------------------------------------
//
//     3.
//
// ���� �������� � �������� �����, 
// ���������� ������������. ������.
//-----------------------------------------   
// ��������� ����������� ����� � �����. ������.

if (Bars - counted_bars<3)
  {
   // ����� ������� ���� ������� ����������, ������ �� �������� ����
   for (shift1=0; shift1<Bars; shift1++) 
     {
      if (zz[shift1]>0.0 && (zzH[shift1]==zz[shift1] || zzL[shift1]==zz[shift1])) 
       {
        timeFr1new=Time[shift1];
        break;
       }
     }
   // ����� ����, �� ������� ������ ��������� ��� �����.
   shift=iBarShift(Symbol(),Period(),afr[0]); 


   // �������� ����� ��� ZigZag
   if ((zzH[shift1]>0 && afrl[0]>0) || (zzL[shift1]>0 && afrh[0]>0))
     {
      ExtFiboStatic=false;
      ExtPitchforkStatic=0;
      ExtFiboExpansion=0;
      ExtFiboFanNum=0;
      
      if (ExtAlert)
       {
        Alert (Symbol(),"  ",Period(),"  �������� ����� ��� ZigZag");
        PlaySound("alert.wav");
       }
     }

   // ��������� �������� �������� ���������� � ���, ������� ��� �����

   // ����������� ����� ���������
   if (timeFr1new!=afr[0])
     {
      flagFrNew=true;
      if (shift>=shift1) numBar=shift; else  numBar=shift1;
      afrm=true;
     }

   // ��������� �� ��������� ��������� �� ������ ���
   if (afrh[0]>0 && zz[shift]==0.0)
     {
      flagFrNew=true;
      if (numBar<shift) numBar=shift;
      afrm=true;
     }
   // ��������� �� �������� ��������� �� ������ ���
   if (afrl[0]>0 && zz[shift]==0.0)
     {
      flagFrNew=true;
      if (numBar<shift) numBar=shift;
      afrm=true;
     }


//-----------3 ��������� �������� ��� �������, �� ������� �� ��� �� ����. ������.

//============= 1 ��������� ��������. ������.
if (afrh[0]-High[shift]!=0 && afrh[0]>0)
  {
   flagFrNew=true;
   numBar=0;
   delete_objects2(afr[0]);
   afrh[0]=High[shift];
   if (ExtFiboFanDinamic) screenFiboFanD();
   if (mFibo[1]==0 && ExtFiboStatic) screenFiboS();
   if (ExtFiboDinamic) screenFiboD();
   if (ExtPitchforkDinamic>0) screenPitchforkD();
   if (ExtVLDinamicColor>0) VLD();
   if (mVL[2]==0 && ExtVLStaticNum>0) VLS();
   if (ExtPitchforkStatic>0)
     {
      if (ExtPitchforkCandle)
        {
         if (iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)==0) screenPitchforkS();
        }
      else
        {
         if (mPitch[2]==0) screenPitchforkS();
        }
     }
   if (mExpansion[2]==0 && ExtFiboExpansion>0) FiboExpansion();
   if (mFan[1]==0 && ExtFiboFanNum>0 && ExtFiboFanColor>0) screenFiboFan();
   if (ExtArcDinamicNum>0) screenFiboArcD();
   if (ExtArcStaticNum>0) screenFiboArcS();
  }
//============= 1 ��������� ��������. �����.
//
//============= 1 ��������� �������. ������.
if (afrl[0]-Low[shift]!=0 && afrl[0]>0)
  {
   flagFrNew=true;
   numBar=0;
   delete_objects2(afr[0]);
   afrl[0]=Low[shift];
   if (mFibo[1]==0 && ExtFiboStatic) screenFiboS();
   if (ExtFiboDinamic) screenFiboD();
   if (ExtFiboFanDinamic) screenFiboFanD();
   if (ExtVLDinamicColor>0) VLD();
   if (mVL[2]==0 && ExtVLStaticNum>0) VLS();
   if (ExtPitchforkStatic>0)
     {
      if (ExtPitchforkCandle)
        {
         if (iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)==0) screenPitchforkS();
        }
      else
        {
         if (mPitch[2]==0) screenPitchforkS();
        }
     }
   if (mExpansion[2]==0 && ExtFiboExpansion>0) FiboExpansion();
   if (mFan[1]==0 && ExtFiboFanNum>0 && ExtFiboFanColor>0) screenFiboFan();
   if (ExtArcDinamicNum>0) screenFiboArcD();
   if (ExtArcStaticNum>0) screenFiboArcS();
  }
//============= 1 ��������� �������. �����.
//-----------3 ��������� �������� ��� �������, �� ������� �� ��� �� ����. �����.


   // ����� ����������� ��������� � �������� �����, ��������� �� ���� ���������. ������.
   countBarEnd=iBarShift(Symbol(),Period(),TimeBarEnd); 
   for (k=0; k<5; k++)
     {

      // �������� ����������.
      if (afrh[k]>0)
        {
         // ����� ����, �� ������� ��� ���� �������
         shift=iBarShift(Symbol(),Period(),afr[k]); 
         if (zz[shift]==0)
           {
            flagFrNew=true;
            if (shift>numBar) numBar=shift;
            afrm=true;
            numHighPrim=shift; numHighLast=0;HighLast=0.0;
            for (k1=shift+1; k1<=countBarEnd; k1++)
              {
               if (zzH[k1]>0) 
                 {
                  if (ZigZagHighLow) HighLast=High[k1]; else HighLast=zzH[k1];
                  numHighLast=k1;

                  nameObj="_" + ExtComplekt + "ph" + Time[numHighPrim] + "_" + Time[numHighLast];

                  numOb=ObjectFind(nameObj);
                  if (numOb>-1)
                    {
                     ObjectDelete(nameObj); 

                     nameObjtxt="_" + ExtComplekt + "phtxt" + Time[numHighPrim] + "_" + Time[numHighLast];

                     ObjectDelete(nameObjtxt);
                    }
                 }
              }
           }
        }
      
      // �������� ���������.
      if (afrl[k]>0)
        {
         // ����� ����, �� ������� ��� ���� �������
         shift=iBarShift(Symbol(),Period(),afr[k]); 
         if (zz[shift]==0)
           {
            flagFrNew=true;
            if (shift>numBar) numBar=shift;

            afrm=true;
            numLowPrim=shift; numLowLast=0;LowLast=10000000;
            for (k1=shift+1; k1<=countBarEnd; k1++)
              {
               if (zzL[k1]>0) 
                 {
                  if (ZigZagHighLow) LowLast=Low[k1]; else LowLast=zzL[k1];
                  numLowLast=k1;

                  nameObj="_" + ExtComplekt + "pl" + Time[numLowPrim] + "_" + Time[numLowLast];

                  numOb=ObjectFind(nameObj);
                  if (numOb>-1)
                    {
                     ObjectDelete(nameObj); 

                     nameObjtxt="_" + ExtComplekt + "pltxt" + Time[numLowPrim] + "_" + Time[numLowLast];

                     ObjectDelete(nameObjtxt);
                    }
                 }
              }
           }
        }
     }
   // ����� ����������� ��������� � �������� �����, ��������� �� ���� ���������. �����.

   // ���������� �������. ������.
   matriza ();
   // ���������� �������. �����.

  }
// ��������� ����������� ����� � �����. �����.
//-----------------------------------------
// ���� �������� � �������� �����, 
// ���������� ������������. �����.
//-----------------------------------------   


  // ������� ���������� ���������. ������.
  countFractal();
  // ������� ���������� ���������. �����.

//-----------------------------------------
//
//     4.
//
// ���� ������ �������������� �����. ������.
//-----------------------------------------   
if (Bars - counted_bars>2)
  {
//-----------1 ��������� ����������. ������.
//+--------------------------------------------------------------------------+
//| ����� ����������� ����� � ����� ��������� � 0.886 ��� ���������� ZigZag-a
//| ��������� ���������� �� �������� ����
//+--------------------------------------------------------------------------+

   numLowPrim=0; numLowLast=0;
   numHighPrim=0; numHighLast=0;

   LowPrim=0.0; LowLast=0.0;
   HighPrim=0.0; HighLast=0.0;

   Angle=-100;
   
   if (flagFrNew && !flagGartle) countFr=1;
   else countFr=ExtFractal;

   for (k=0; (k<Bars-1 && countHigh1>0 && countFr>0); k++)
     {
      if (zzL[k]>0.0 && (zzL[k]<LowPrim || LowPrim==0.0) && HighPrim>0 && zzL[k]==zz[k])
        {
         if (ZigZagHighLow) LowPrim=Low[k]; else LowPrim=zzL[k]; 
         numLowPrim=k;
        }
      if (zzH[k]>0.0 && zzH[k]==zz[k])
        {
         if (HighPrim>0) 
           {

            if (ZigZagHighLow) HighLast=High[k]; else HighLast=zzH[k];
            numHighLast=k;

            HL=HighLast-LowPrim;
            kj=(HighPrim-HighLast)*1000/(numHighLast-numHighPrim);
            if (HL>0 && (Angle>=kj || Angle==-100))  // �������� ���� ������� �����
              {
               Angle=kj;
               // �������� ����� � ���������� �������
               HLp=HighPrim-LowPrim;
               k1=MathCeil((numHighPrim+numHighLast)/2);
               kj=HLp/HL;

               
               if (ExtPPWithBars==0) PPWithBars="";
               else if (ExtPPWithBars==1) PPWithBars=" ("+(numHighLast-numHighPrim)+")";
               else if (ExtPPWithBars==2) PPWithBars=" ("+(numHighLast-numLowPrim)+"-"+(numLowPrim-numHighPrim)+")";
               else if (ExtPPWithBars==3)
                 {
                  int_to_d1=(numLowPrim-numHighPrim);
                  int_to_d2=(numHighLast-numLowPrim);
                  int_to_d=int_to_d1/int_to_d2;
                  PPWithBars=" ("+DoubleToStr(int_to_d,2)+")";
                 }
               else if (ExtPPWithBars==4)
                 {
                  int_to_d1=(Time[numLowPrim]-Time[numHighPrim]);
                  int_to_d2=(Time[numHighLast]-Time[numLowPrim]);
                  int_to_d=int_to_d1/int_to_d2;
                  PPWithBars=" ("+DoubleToStr(int_to_d,2)+")";
                 }
               else if (ExtPPWithBars==5)
                 {
                  int_to_d1=(numLowPrim-numHighPrim)*(High[numHighPrim]-Low[numLowPrim]);
                  int_to_d2=(numHighLast-numLowPrim)*(High[numHighLast]-Low[numLowPrim]);
                  int_to_d=int_to_d1/int_to_d2;
                  PPWithBars=" ("+DoubleToStr(int_to_d,2)+")";
                 }
               else if (ExtPPWithBars==7)
                 {
                  int_to_d1=((High[numHighLast]-Low[numLowPrim])/Point)/(numHighLast-numLowPrim);
                  int_to_d2=((High[numHighPrim]-Low[numLowPrim])/Point)/(numLowPrim-numHighPrim);
                  PPWithBars=" ("+DoubleToStr(int_to_d1,3)+"/"+DoubleToStr(int_to_d2,3)+")";
                 }
// ExtPPWithBars=6 ����������� ��������� ������� � ������� ���������� �� ����������� "���������"

               ExtLine_=ExtLine;
               if (kj>0.1 && kj<9.36)
                 {
                  // �������� ���������� ������� (����� ���������). % �������������� ����� �����������
                  kk=kj;
                  k2=1;
                  Pesavento_patterns();
                  if (k2<0)
                    // ������� �������������� ����� ��������� � 0.886
                    {
                    ExtLine_=ExtLine886;
                    if (ExtHidden!=4)
                      {
                       nameObj="_" + ExtComplekt + "phtxt" + Time[numHighPrim] + "_" + Time[numHighLast];
                       ObjectCreate(nameObj,OBJ_TEXT,0,Time[k1],(HighPrim+HighLast)/2);

                       if (ExtPPWithBars==6)
                         {
                          int_to_d=MathAbs((kk-kj)/kk)*100;
                          PPWithBars=" ("+DoubleToStr((LowPrim+(HighLast-LowPrim)*kk-HighPrim)/Point,0)+"/"+DoubleToStr(int_to_d,2)+"%)";
                         }
                       descript=txtkk;
                       ObjectSetText(nameObj,txtkk+PPWithBars,ExtSizeTxt,"Arial", colorPPattern);
                       if (ExtPPWithBars==6) PPWithBars="";
                      }
                     }
                  else
                    // ������� �������������� (�� ��������� � 0.886)
                    {
                     if (ExtHidden==1 || ExtHidden==4)
                       {
                        nameObj="_" + ExtComplekt + "phtxt" + Time[numHighPrim] + "_" + Time[numHighLast];

                        ObjectCreate(nameObj,OBJ_TEXT,0,Time[k1],(HighPrim+HighLast)/2);

                        descript=DoubleToStr(kk,3);
                        if (ExtDeltaType==3)
                          {
                           ObjectSetText(nameObj,""+DoubleToStr(kk,3)+PPWithBars,ExtSizeTxt,"Arial",colorPPattern);
                          }
                        else
                          {
                           ObjectSetText(nameObj,""+DoubleToStr(kk,2)+PPWithBars,ExtSizeTxt,"Arial",colorPPattern);
                          }
                       }
                    }

                  if ((ExtHidden==2 && k2<0) || ExtHidden!=2)
                    {
                     nameObj="_" + ExtComplekt + "ph" + Time[numHighPrim] + "_" + Time[numHighLast];
                     ObjectCreate(nameObj,OBJ_TREND,0,Time[numHighLast],HighLast,Time[numHighPrim],HighPrim);

                     if (descript_b) ObjectSetText(nameObj,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" PPesavento "+"Line High "+descript);
                     ObjectSet(nameObj,OBJPROP_RAY,false);
                     ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DOT);
                     ObjectSet(nameObj,OBJPROP_COLOR,ExtLine_);
                     ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
                    }
                  if (ExtFiboZigZag) k=countBarEnd;
                 }
              }
           }
         else 
           {
            if (ZigZagHighLow) HighPrim=High[k]; else HighPrim=zzH[k];
            numHighPrim=k;
           }
        }
       // ������� �� ��������� ���������
       if (k>countBarEnd) 
         {
          k=numHighPrim+1; countHigh1--; countFr--;

          numLowPrim=0; numLowLast=0;
          numHighPrim=0; numHighLast=0;

          LowPrim=0.0; LowLast=0.0;
          HighPrim=0.0; HighLast=0.0;
   
          Angle=-100;
         }
     }
//-----------1 ��������� ����������. �����.

//-----------2 ��������� ���������. ������.
//+-------------------------------------------------------------------------+
//| ����� ����������� ����� � ����� ��������� � 0.886 ��� ��������� ZigZag-a
//| ��������� ���� �� �������� ����
//+-------------------------------------------------------------------------+

   numLowPrim=0; numLowLast=0;
   numHighPrim=0; numHighLast=0;

   LowPrim=0.0; LowLast=0.0;
   HighPrim=0.0; HighLast=0.0;
   
   Angle=-100;

   if (flagFrNew && !flagGartle) countFr=1;
   else countFr=ExtFractal;
   flagFrNew=false;
   flagGartle=false;

   for (k=0; (k<Bars-1 && countLow1>0 && countFr>0); k++)
     {
      if (zzH[k]>HighPrim && LowPrim>0)
        {
         if (ZigZagHighLow) HighPrim=High[k]; else HighPrim=zzH[k];
         numHighPrim=k;
        }

      if (zzL[k]>0.0 && zzL[k]==zz[k]) 
        {
         if (LowPrim>0) 
           {

            if (ZigZagHighLow) LowLast=Low[k]; else LowLast=zzL[k];
            numLowLast=k;

            // ����� ����������� ����� � ��������� ��������������(����� ���������)
            HL=HighPrim-LowLast;
            kj=(LowPrim-LowLast)*1000/(numLowLast-numLowPrim);
            if (HL>0 && (Angle<=kj || Angle==-100))  // �������� ���� ������� �����
              {
               Angle=kj;

               HLp=HighPrim-LowPrim;
               k1=MathCeil((numLowPrim+numLowLast)/2);
               kj=HLp/HL;

               if (ExtPPWithBars==0) PPWithBars="";
               else if (ExtPPWithBars==1) PPWithBars=" ("+(numLowLast-numLowPrim)+")";
               else if (ExtPPWithBars==2) PPWithBars=" ("+(numLowLast-numHighPrim)+"-"+(numHighPrim-numLowPrim)+")";
               else if (ExtPPWithBars==3)
                 {
                  int_to_d1=(numHighPrim-numLowPrim);
                  int_to_d2=(numLowLast-numHighPrim);
                  int_to_d=int_to_d1/int_to_d2;
                  PPWithBars=" ("+DoubleToStr(int_to_d,2)+")";
                 }
               else if (ExtPPWithBars==4)
                 {
                  int_to_d1=(Time[numHighPrim]-Time[numLowPrim]);
                  int_to_d2=(Time[numLowLast]-Time[numHighPrim]);
                  int_to_d=int_to_d1/int_to_d2;
                  PPWithBars=" ("+DoubleToStr(int_to_d,2)+")";
                 }
               else if (ExtPPWithBars==5)
                 {
                  int_to_d1=(numHighPrim-numLowPrim)*(High[numHighPrim]-Low[numLowPrim]);
                  int_to_d2=(numLowLast-numHighPrim)*(High[numHighPrim]-Low[numLowLast]);
                  int_to_d=int_to_d1/int_to_d2;
                  PPWithBars=" ("+DoubleToStr(int_to_d,2)+")";
                 }
               else if (ExtPPWithBars==7)
                 {
                  int_to_d1=((High[numHighPrim]-Low[numLowLast])/Point)/(numLowLast-numHighPrim);
                  int_to_d2=((High[numHighPrim]-Low[numLowPrim])/Point)/(numHighPrim-numLowPrim);
                  PPWithBars=" ("+DoubleToStr(int_to_d1,3)+"/"+DoubleToStr(int_to_d2,3)+")";
                 }
// ExtPPWithBars=6 ����������� ��������� ������� � ������� ���������� �� ����������� "���������"

               ExtLine_=ExtLine;
               if ( kj>0.1 && kj<9.36)
                 {
                  // �������� ���������� ������� (����� ���������). % �������������� ����� ����������
                  kk=kj;
                  k2=1;
                  Pesavento_patterns();
                  if (k2<0)
                  // ������� �������������� ����� ��������� � 0.886
                    {
                     ExtLine_=ExtLine886;
                     if (ExtHidden!=4)                  
                       {
                        nameObj="_" + ExtComplekt + "pltxt" + Time[numLowPrim] + "_" + Time[numLowLast];
                        ObjectCreate(nameObj,OBJ_TEXT,0,Time[k1],(LowPrim+LowLast)/2);

                        if (ExtPPWithBars==6)
                          {
                           int_to_d=MathAbs((kk-kj)/kk)*100;
                           PPWithBars=" ("+DoubleToStr((HighPrim-(HighPrim-LowLast)*kk-LowPrim)/Point,0)+"/"+DoubleToStr(int_to_d,2)+"%)";
                          }
                        descript=txtkk;
                        ObjectSetText(nameObj,txtkk+PPWithBars,ExtSizeTxt,"Arial", colorPPattern);
                        if (ExtPPWithBars==6) PPWithBars="";
                       }
                    }
                  else 
                    // ������� �������������� (�� ��������� � 0.886)
                    { 
                     if (ExtHidden==1 || ExtHidden==4)
                       {
                        nameObj="_" + ExtComplekt + "pltxt" + Time[numLowPrim] + "_" + Time[numLowLast];

                        ObjectCreate(nameObj,OBJ_TEXT,0,Time[k1],(LowPrim+LowLast)/2);

                        descript=DoubleToStr(kk,3);
                        if (ExtDeltaType==3)
                          {
                           ObjectSetText(nameObj,""+DoubleToStr(kk,3)+PPWithBars,ExtSizeTxt,"Arial",colorPPattern);
                          }
                        else
                          {
                           ObjectSetText(nameObj,""+DoubleToStr(kk,2)+PPWithBars,ExtSizeTxt,"Arial",colorPPattern);
                          }
                       }
                     }
                     
                   if ((ExtHidden==2 && k2<0) || ExtHidden!=2)
                     {
                      nameObj="_" + ExtComplekt + "pl" + Time[numLowPrim] + "_" + Time[numLowLast];

                      ObjectCreate(nameObj,OBJ_TREND,0,Time[numLowLast],LowLast,Time[numLowPrim],LowPrim);

                      if (descript_b) ObjectSetText(nameObj,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" PPesavento "+"Line Low "+descript);
                      ObjectSet(nameObj,OBJPROP_RAY,false);
                      ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DOT);
                      ObjectSet(nameObj,OBJPROP_COLOR,ExtLine_);
                      ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
                     }
                   if (ExtFiboZigZag) k=countBarEnd;
                  }
               }
           }
         else
           {
            numLowPrim=k; 
            if (ZigZagHighLow) LowPrim=Low[k]; else LowPrim=zzL[k];
           }
        }
       // ������� �� ��������� ���������
       if (k>countBarEnd) 
         {
          k=numLowPrim+1; countLow1--; countFr--;

          numLowPrim=0; numLowLast=0;
          numHighPrim=0; numHighLast=0;

          LowPrim=0.0; LowLast=0.0;
          HighPrim=0.0; HighLast=0.0;
  
          Angle=-100;
         }
     }

//-----------2 ��������� ���������. �����.

  }
//-----------------------------------------
// ���� ������ �������������� �����. �����.
//-----------------------------------------   

//======================
//======================
//======================
  } // ���������� �� ����� ��������. �����.
// �����
  } // start


//----------------------------------------------------
//  ������������ � �������
//----------------------------------------------------

//--------------------------------------------------------
// ������� ���������� �����������. ��������� � ����������. ������.
//--------------------------------------------------------
void countFractal()
  {
   int shift;
   countLow1=0;
   countHigh1=0;
   if (flagFrNew && !flagGartle)
     {
      for(shift=0; shift<=numBar; shift++)
        {
         if (zzL[shift]>0.0) {countLow1++;}
         if (zzH[shift]>0.0) {countHigh1++;}    
        }

      numBar=0;  
      counted_bars=Bars-4;
     }
   else
     {
      if (flagGartle)  {counted_bars=0;}
      for(shift=0; shift<=countBarEnd; shift++)
        {
         if (zzL[shift]>0.0) {countLow1++;}
         if (zzH[shift]>0.0) {countHigh1++;}
        }
     }
  }
//--------------------------------------------------------
// ������� ���������� �����������. ��������� � ����������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ������������ �������. ������.
//
// ������� ������������ ��� ������ ����������� �����������.
// ��� ���������� ����������� �������������� ��������� ������������ ZigZag-a.
//
// ����� ��������� ����������� � ������������ ���� � ����� ���������,
// ���� �������...
//------------------------------------------------------
void matriza()
  {
   if (afrm)
     {
      afrm=false;
      int shift,k;
      
      k=0;
      for (shift=0; shift<Bars && k<10; shift++)
        {
         if (zz[shift]>0)
           {
            afrx[k]=zz[shift];
            afr[k]=Time[shift];
            if (zz[shift]==zzL[shift])
              {
               if (ZigZagHighLow) afrl[k]=Low[shift]; 
               else
                 {
                  if (k==0) afrl[k]=Low[shift]; else  afrl[k]=zzL[shift];
                 }
               afrh[k]=0.0;
              }
            if (zz[shift]==zzH[shift])
              {
               if (ZigZagHighLow) afrh[k]=High[shift]; 
               else
                 {
                  if (k==0) afrh[k]=High[shift]; else afrh[k]=zzH[shift];
                 }
               afrl[k]=0.0;
              }
            k++;
           }
        }
      // ����� ��� �������
      if (ExtPitchforkStatic>0)
        {
         if (mPitch[2]>0) {screenPitchforkS(); ExtPitchforkStatic=0;}
         if (ExtPitchforkCandle)
           {
            if (iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)==0) screenPitchforkS();
           }
         else
           {
            if (mPitch[2]==0) screenPitchforkS();
           }
        }
      if (ExtPitchforkDinamic>0) screenPitchforkD();

      // ����� ����������� � ������������ ���.
      if (ExtFiboStatic)
        {
         if (mFibo[1]>0) {ExtFiboStatic=false; screenFiboS();}
         if (mFibo[1]==0) screenFiboS();
        }
      if (ExtFiboDinamic) {screenFiboD();}

      // ���������� ���������
      if (ExtFiboExpansion>0)
        {
         if (mExpansion[2]>0) {FiboExpansion(); ExtFiboExpansion=0;}
         if (mExpansion[2]==0) FiboExpansion();
        }

      // ����� ����������
      if (ExtFiboFanNum>0 && ExtFiboFanColor>0)
        {
         if (mFan[1]>0) {screenFiboFan(); ExtFiboFanNum=0;}
         if (mFan[1]==0) screenFiboFan();
        }
      if (ExtFiboFanDinamic) screenFiboFanD();

      // ����� Versum Levels
      if (ExtVLStaticColor>0)
        {
         if (mVL[2]>0) {ExtVLStaticNum=0; VLS();}
         if (mVL[2]==0) VLS();
        }
      if (ExtVLDinamicColor>0) {VLD();}

      // ����� �������
      if (ExtArcDinamicNum>0) screenFiboArcD();
      if (ExtArcStaticNum>0) {screenFiboArcS(); ExtArcStaticNum=0;}

      // ����� ��������� Gartley
      if (ExtGartleyOnOff)
        {
         switch (ExtIndicator)
           {
            case 0     : {_Gartley("ExtIndicator=0_" + minBars+"/"+ExtDeviation+"/"+ExtBackstep);break;}
            case 1     : {_Gartley("ExtIndicator=1_" + minSize+"/"+minPercent);break;}
            case 2     : {_Gartley("ExtIndicator=2_" + minBars+"/"+minSize);break;}
            case 3     : {_Gartley("ExtIndicator=3_" + minBars);break;}
            case 4     : {_Gartley("ExtIndicator=4_" + minSize);break;}
            case 5     : {_Gartley("ExtIndicator=5_" + minBars);break;}
            case 6     : {_Gartley("ExtIndicator=6_" + minBars+"/"+ExtDeviation+"/"+ExtBackstep);break;}
            case 7     : {_Gartley("ExtIndicator=7_" + minBars);break;}
            case 8     : {_Gartley("ExtIndicator=8_" + minBars+"/"+ExtDeviation);break;}
            case 10    : {_Gartley("ExtIndicator=10_" + minBars);break;}
            case 12    : {_Gartley("ExtIndicator=12_" + minBars);break;}
           }
         if (vPatOnOff==1 && vPatNew==0)
           {
            vPatNew=1;
            if (ExtSendMail) _SendMail("There was a pattern","on  " + Symbol() + " " + Period() + " pattern " + vBullBear + " " + vNamePattern);
           }
         else if (vPatOnOff==0 && vPatNew==1) {vPatNew=0; FlagForD=true;}
        }
      
      ExtSave=false;
     }
  }
//--------------------------------------------------------
// ������������ �������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� Versum Levels �����������. ������.
//--------------------------------------------------------
void VLS()
  {
   VL(mVL[0],mVL[1],mVL[2],ExtVLStaticColor,"VLS");
  }
//--------------------------------------------------------
// ����� Versum Levels �����������. ������.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� Versum Levels ������������. ������.
//--------------------------------------------------------
void VLD()
  {
   VL(2,1,0,ExtVLDinamicColor,"VLD");
  }
//--------------------------------------------------------
// ����� Versum Levels ������������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// Versum Levels. ������.
//--------------------------------------------------------
void VL(int na,int nb,int nc,color color_line,string vl)
  {
   double line_pesavento[7]={0.236, 0.382, 0.447, 0.5, 0.618, 0.786, 0.886}, line_fibo[7]={0.236, 0.382, 0.455, 0.5, 0.545, 0.618, 0.764};
   int c_bar1, c_bar2, i;
   double H_L, mediana, tangens, cena;

   c_bar1=iBarShift(Symbol(),Period(),afr[na])-iBarShift(Symbol(),Period(),afr[nb]); // ���������� ��� � ������� AB
   c_bar2=iBarShift(Symbol(),Period(),afr[nb])-iBarShift(Symbol(),Period(),afr[nc]); // ���������� ��� � ������� ��
   if (afrl[na]>0)
    {
     H_L=afrh[nb]-afrl[nc]; // ������ ������� ��

     for (i=0; i<7; i++)
       {
        if (ExtFiboType==1)
          {
           mediana=line_pesavento[i]*H_L+afrl[nc];
           tangens=(mediana-afrl[na])/(c_bar1+(1-line_pesavento[i])*c_bar2);
           cena=c_bar2*line_pesavento[i]*tangens+mediana;
           nameObj=vl+i+" " + ExtComplekt+"_";
           ObjectDelete(nameObj);
           ObjectCreate(nameObj,OBJ_TREND,0,afr[na],afrl[na],afr[nc],cena);
           ObjectSetText(nameObj,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" "+vl+" "+DoubleToStr(line_pesavento[i]*100,1)+"");
           ObjectSet(nameObj,OBJPROP_COLOR,color_line);
          }
        else
          {
           mediana=line_fibo[i]*H_L+afrl[nc];
           tangens=(mediana-afrl[na])/(c_bar1+(1-line_fibo[i])*c_bar2);
           cena=c_bar2*line_fibo[i]*tangens+mediana;
           nameObj=vl+i+" " + ExtComplekt+"_";
           ObjectDelete(nameObj);
           ObjectCreate(nameObj,OBJ_TREND,0,afr[na],afrl[na],afr[nc],cena);
           ObjectSetText(nameObj,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" "+vl+" "+DoubleToStr(line_fibo[i]*100,1)+"");
           ObjectSet(nameObj,OBJPROP_COLOR,color_line);
          }
       }
    }
   else
    {
     H_L=afrh[nc]-afrl[nb]; // ������ ������� ��

     for (i=0; i<7; i++)
       {
        if (ExtFiboType==1)
          {
           mediana=afrh[nc]-line_pesavento[i]*H_L;
           tangens=(afrh[na]-mediana)/(c_bar1+(1-line_pesavento[i])*c_bar2);
           cena=mediana-c_bar2*line_pesavento[i]*tangens;
           nameObj=vl+i+" " + ExtComplekt+"_";
           ObjectDelete(nameObj);
           ObjectCreate(nameObj,OBJ_TREND,0,afr[na],afrh[na],afr[nc],cena);
           ObjectSetText(nameObj,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" "+vl+" "+DoubleToStr(line_pesavento[i]*100,1)+"");
           ObjectSet(nameObj,OBJPROP_COLOR,color_line);
          }
        else
          {
           mediana=afrh[nc]-line_fibo[i]*H_L;
           tangens=(afrh[na]-mediana)/(c_bar1+(1-line_fibo[i])*c_bar2);
           cena=mediana-c_bar2*line_fibo[i]*tangens;
           nameObj=vl+i+" " + ExtComplekt+"_";
           ObjectDelete(nameObj);
           ObjectCreate(nameObj,OBJ_TREND,0,afr[na],afrh[na],afr[nc],cena);
           ObjectSetText(nameObj,"ZUP"+ExtComplekt+" zz"+ExtIndicator+" "+vl+" "+DoubleToStr(line_fibo[i]*100,1)+"");
           ObjectSet(nameObj,OBJPROP_COLOR,color_line);
          }
       }
    }
  }
//--------------------------------------------------------
// Versum Levels. �����.
//--------------------------------------------------------


//--------------------------------------------------------
// ����� ��� ������� �����������. ������.
//--------------------------------------------------------
void screenPitchforkS()
  {
   int i,k1,n,nbase1,nbase2;
   double a1,b1,c1,ab1,bc1,ab2,bc2,tangens,n1,cl1,ch1,cena;
   datetime ta1,tb1,tc1,tab2,tbc2,tcl1,tch1;
   bool fo1=false,fo2=false;
   int    pitch_time[]={0,0,0}; 
   double pitch_cena[]={0,0,0};
   double TLine, m618=0.618, m382=0.382;
   int mirror1, mirror2;

   if (ExtPitchforkCandle)
     {
      if (iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)==0)
        {
         if (ExtPitchfork_1_HighLow)
           {
            mPitchCena[2]=High[iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)];
           }
         else
           {
            mPitchCena[2]=Low[iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)];
           }
        }
     }

   if (ExtPitchforkCandle)
     {
      cena=mPitchCena[0];
      if (ExtPitchfork_1_HighLow)
        {
         if (ExtCM_0_1A_2B_Static==1)
           {
            cena=mPitchCena[0]-(mPitchCena[0]-mPitchCena[1])*ExtCM_FiboStatic;
           }
         else if (ExtCM_0_1A_2B_Static==4)
           {
            mPitchTimeSave=mPitchTime[0];
            mPitchTime[0]=mPitchTime[1];
            if (maxGipotenuza4(mPitchTime,mPitchCena))
              {
               cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m618;
              }
            else
              {
               cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m382;
              }
           }
         else if (ExtCM_0_1A_2B_Static==5)
           {
            mPitchTimeSave=mPitchTime[0];
            mPitchTime[0]=mPitchTime[1];
            if (maxGipotenuza5(mPitchTime,mPitchCena))
              {
               cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m618;
              }
            else
              {
               cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m382;
              }
           }
         else if (ExtCM_0_1A_2B_Static>1)
           {
            if (ExtCM_0_1A_2B_Static==2) mPitchTime[0]=mPitchTime[1];
            cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*ExtCM_FiboStatic;
           }
        }
      else
        {
         if (ExtCM_0_1A_2B_Static==1)
           {
            cena=mPitchCena[0]+(mPitchCena[1]-mPitchCena[0])*ExtCM_FiboStatic;
           }
         else if (ExtCM_0_1A_2B_Static==4)
           {
            mPitchTimeSave=mPitchTime[0];
            mPitchTime[0]=mPitchTime[1];
            if (maxGipotenuza4(mPitchTime,mPitchCena))
              {
               cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m618;
              }
            else
              {
               cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m382;
              }
           }
         else if (ExtCM_0_1A_2B_Static==5)
           {
            mPitchTimeSave=mPitchTime[0];
            mPitchTime[0]=mPitchTime[1];
            if (maxGipotenuza5(mPitchTime,mPitchCena))
              {
               cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m618;
              }
            else
              {
               cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m382;
              }
           }
         else if (ExtCM_0_1A_2B_Static>1)
           {
            if (ExtCM_0_1A_2B_Static==2) mPitchTime[0]=mPitchTime[1];
            cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*ExtCM_FiboStatic;
           }
        }
     }
   else
     {
      mPitchTime[0]=afr[mPitch[0]]; mPitchTime[1]=afr[mPitch[1]]; mPitchTime[2]=afr[mPitch[2]];

      if (afrl[mPitch[0]]>0)
        {
         cena=afrl[mPitch[0]]; 
         mPitchCena[0]=afrl[mPitch[0]]; mPitchCena[1]=afrh[mPitch[1]]; mPitchCena[2]=afrl[mPitch[2]];
         if (ExtCM_0_1A_2B_Static==1)
           {
            cena=mPitchCena[0]+(mPitchCena[1]-mPitchCena[0])*ExtCM_FiboStatic;
           }
         else if (ExtCM_0_1A_2B_Static==4)
           {
            mPitchTimeSave=mPitchTime[0];
            mPitchTime[0]=mPitchTime[1];
            if (maxGipotenuza4(mPitchTime,mPitchCena))
              {
               cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m618;
              }
            else
              {
               cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m382;
              }
           }
         else if (ExtCM_0_1A_2B_Static==5)
           {
            mPitchTimeSave=mPitchTime[0];
            mPitchTime[0]=mPitchTime[1];
            if (maxGipotenuza5(mPitchTime,mPitchCena))
              {
               cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m618;
              }
            else
              {
               cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m382;
              }
           }
         else if (ExtCM_0_1A_2B_Static>1)
           {
            if (ExtCM_0_1A_2B_Static==2) mPitchTime[0]=mPitchTime[1];
            cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*ExtCM_FiboStatic;
           }
        }
      else
        {
         cena=afrh[mPitch[0]];
         mPitchCena[0]=afrh[mPitch[0]]; mPitchCena[1]=afrl[mPitch[1]]; mPitchCena[2]=afrh[mPitch[2]];
         if (ExtCM_0_1A_2B_Static==1)
           {
            cena=mPitchCena[0]-(mPitchCena[0]-mPitchCena[1])*ExtCM_FiboStatic;
           }
         else if (ExtCM_0_1A_2B_Static==4)
           {
            mPitchTimeSave=mPitchTime[0];
            mPitchTime[0]=mPitchTime[1];
            if (maxGipotenuza4(mPitchTime,mPitchCena))
              {
               cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m618;
              }
            else
              {
               cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m382;
              }
           }
         else if (ExtCM_0_1A_2B_Static==5)
           {
            mPitchTimeSave=mPitchTime[0];
            mPitchTime[0]=mPitchTime[1];
            if (maxGipotenuza5(mPitchTime,mPitchCena))
              {
               cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m618;
              }
            else
              {
               cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m382;
              }
           }
         else if (ExtCM_0_1A_2B_Static>1)
           {
            if (ExtCM_0_1A_2B_Static==2) mPitchTime[0]=mPitchTime[1];
            cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*ExtCM_FiboStatic;
           }
        }
     }

   mPitchCena[0]=cena;

   if (ExtFiboFanStatic) {ExtFiboFanStatic=false; screenFiboFanS();}
 
   nameObj="pmedianaS" + ExtComplekt+"_";
   ObjectDelete(nameObj);

   if (ExtSave)
     {
      if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
        {
         nameObj=nameObj + save;
        }
      else
        {
         if (mPitch[2]>0)
           {
            nameObj=nameObj + save;
           }
        }
     }

   coordinaty_1_2_mediany_AP(mPitchCena[0], mPitchCena[1], mPitchCena[2], mPitchTime[0], mPitchTime[1], mPitchTime[2], tab2, tbc2, ab1, bc1);

   pitch_time[0]=tab2;pitch_cena[0]=ab1;

   if (ExtPitchforkStatic==2)
     {
      ObjectCreate(nameObj,OBJ_TREND,0,tab2,ab1,tbc2,bc1);
      ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DASH);
      ObjectSet(nameObj,OBJPROP_COLOR,ExtLinePitchforkS);
      ObjectSet(nameObj,OBJPROP_BACK,ExtBack);

      nameObj="1-2pmedianaS" + ExtComplekt+"_";

      if (ExtSave)
        {
         if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
           {
            nameObj=nameObj + save;
           }
         else
           {
            if (mPitch[2]>0)
              {
               nameObj=nameObj + save;
              }
           }
        }
      ObjectDelete(nameObj);
      ObjectCreate(nameObj,OBJ_TEXT,0,tab2,ab1+3*Point);
      ObjectSetText(nameObj,"     1/2 ML",9,"Arial", ExtLinePitchforkS);
     }   

   nameObj="pitchforkS" + ExtComplekt+"_";
   if (ExtSave)
     {
      if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
        {
         nameObj=nameObj + save;
        }
      else
        {
         if (mPitch[2]>0)
           {
            nameObj=nameObj + save;
           }
        }
     }

   ObjectDelete(nameObj);

   if (ExtPitchforkStatic!=4)
     {
      pitch_time[0]=mPitchTime[0];pitch_cena[0]=mPitchCena[0];
      if (ExtPitchforkStatic==3) pitch_cena[0]=ab1;
     }
   pitch_time[1]=mPitchTime[1];pitch_cena[1]=mPitchCena[1];
   pitch_time[2]=mPitchTime[2];pitch_cena[2]=mPitchCena[2];

   ObjectCreate(nameObj,OBJ_PITCHFORK,0,pitch_time[0],pitch_cena[0],pitch_time[1],pitch_cena[1],pitch_time[2],pitch_cena[2]);
   if (ExtPitchforkStyle<5)
     {
      ObjectSet(nameObj,OBJPROP_STYLE,ExtPitchforkStyle);
     }
   else if(ExtPitchforkStyle<11)
     {
      ObjectSet(nameObj,OBJPROP_WIDTH,ExtPitchforkStyle-5);
     }
   ObjectSet(nameObj,OBJPROP_COLOR,ExtLinePitchforkS);
   ObjectSet(nameObj,OBJPROP_BACK,ExtBack);

   if (ExtFiboFanMedianaStaticColor>0)
     {
      coordinaty_mediany_AP(pitch_cena[0], pitch_cena[1], pitch_cena[2], pitch_time[0], pitch_time[1], pitch_time[2], tb1, b1);      

      nameObj="FanMedianaStatic" + ExtComplekt+"_";
/*
      if (ExtSave)
        {
         if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
           {
            nameObj=nameObj + save;
           }
         else
           {
            if (mPitch[2]>0)
              {
               nameObj=nameObj + save;
              }
           }
        }
*/
      ObjectDelete(nameObj);

      ObjectSet(nameObj,OBJPROP_COLOR,CLR_NONE);
      ObjectCreate(nameObj,OBJ_FIBOFAN,0,pitch_time[0],pitch_cena[0],tb1,b1);
      ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DASH);
      ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtFiboFanMedianaStaticColor);
      ObjectSet(nameObj,OBJPROP_BACK,ExtBack);

      if (ExtFiboType==0)
        {
         screenFibo_st();
        }
      else if (ExtFiboType==1)
        {
         screenFibo_Pesavento();
        }
      else if (ExtFiboType==2)
        {
         ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi);
         for (i=0;i<Sizefi;i++)
           {
            ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi[i]);
            ObjectSetFiboDescription(nameObj, i, fitxt100[i]); 
           }
        }
     }
//-------------------------------------------------------

   if (ExtUTL)
     {
      nameObj="UTL" + ExtComplekt+"_";
      if (ExtSave)
        {
         if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
           {
            nameObj=nameObj + save;
           }
         else
           {
            if (mPitch[2]>0)
              {
               nameObj=nameObj + save;
              }
           }
        }

      ObjectDelete(nameObj);
      if (pitch_cena[1]>pitch_cena[2])
        {
         ObjectCreate(nameObj,OBJ_TREND,0,pitch_time[0],pitch_cena[0],pitch_time[1],pitch_cena[1]);
        }
      else
        {
         ObjectCreate(nameObj,OBJ_TREND,0,pitch_time[0],pitch_cena[0],pitch_time[2],pitch_cena[2]);
        }
      ObjectSet(nameObj,OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet(nameObj,OBJPROP_COLOR,ExtLinePitchforkS);
      ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
     }

   if (ExtPivotZoneStaticColor>0 && ExtPitchforkStatic<4) PivotZone(pitch_time, pitch_cena, ExtPivotZoneStaticColor, "PivotZoneS");

   if (ExtLTL)
     {
      nameObj="LTL" + ExtComplekt+"_";
      if (ExtSave)
        {
         if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
           {
            nameObj=nameObj + save;
           }
         else
           {
            if (mPitch[2]>0)
              {
               nameObj=nameObj + save;
              }
           }
        }

      ObjectDelete(nameObj);
      if (pitch_cena[1]>pitch_cena[2])
        {
         ObjectCreate(nameObj,OBJ_TREND,0,pitch_time[0],pitch_cena[0],pitch_time[2],pitch_cena[2]);
        }
      else
        {
         ObjectCreate(nameObj,OBJ_TREND,0,pitch_time[0],pitch_cena[0],pitch_time[1],pitch_cena[1]);
        }
      ObjectSet(nameObj,OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet(nameObj,OBJPROP_COLOR,ExtLinePitchforkS);
      ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
     }
//-------------------------------------------------------

   if (ExtISLStatic)
     {
      n1=iBarShift(Symbol(),Period(),pitch_time[0])-(iBarShift(Symbol(),Period(),pitch_time[1])+iBarShift(Symbol(),Period(),pitch_time[2]))/2.0;
      ta1=pitch_time[1];
      a1=pitch_cena[1];
      tangens=(pitch_cena[0]-(pitch_cena[1]+pitch_cena[2])/2.0)/n1;

      ML_RL400(tangens, pitch_cena, pitch_time, tb1, b1, true);

      tc1=pitch_time[2];
      c1=pitch_cena[2];

      nameObj="ISL_S" + ExtComplekt+"_";
      if (ExtSave)
        {
         if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
           {
            nameObj=nameObj + save;
           }
         else
           {
            if (mPitch[2]>0)
              {
               nameObj=nameObj + save;
              }
           }
         }

         ObjectDelete(nameObj);

         ObjectCreate(nameObj,OBJ_FIBOCHANNEL,0,ta1,a1,tb1,b1,tc1,c1);
         ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtLinePitchforkS);
         ObjectSet(nameObj,OBJPROP_LEVELSTYLE,ExtPitchforkStyle);
         ObjectSet(nameObj,OBJPROP_RAY,false);
         ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
         ObjectSet(nameObj,OBJPROP_COLOR,CLR_NONE);
         ObjectSet(nameObj,OBJPROP_FIBOLEVELS,6);

         if (ExtFiboType==1)
           {
            ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+0,-0.886);
            ObjectSetFiboDescription(nameObj, 0, "   I S L 88.6"); 

            ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+1,-0.786);
            ObjectSetFiboDescription(nameObj, 1, "    I S L 78.6"); 

            ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+2,-0.618);
            ObjectSetFiboDescription(nameObj, 2, "    I S L 61.8"); 
           }
         else
           {
            ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+0,-0.854);
            ObjectSetFiboDescription(nameObj, 0, "   I S L 85.4"); 

            ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+1,-0.764);
            ObjectSetFiboDescription(nameObj, 1, "    I S L 76.4"); 

            ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+2,-0.618);
            ObjectSetFiboDescription(nameObj, 2, "    I S L 61.8"); 
           }

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+3,-0.382);
         ObjectSetFiboDescription(nameObj, 3, "    I S L 38.2"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+4,-0.236);
         ObjectSetFiboDescription(nameObj, 4, "    I S L 23.6"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+5,-0.146);
         ObjectSetFiboDescription(nameObj, 5, "    I S L 14.6"); 
     }

//-------------------------------------------------------

   if (ExtUWL || ExtLWL)
     {
      n1=iBarShift(Symbol(),Period(),pitch_time[0])-(iBarShift(Symbol(),Period(),pitch_time[1])+iBarShift(Symbol(),Period(),pitch_time[2]))/2.0;
      ta1=pitch_time[0];
      tb1=Time[0];
      a1=pitch_cena[0];
      tangens=(pitch_cena[0]-(pitch_cena[1]+pitch_cena[2])/2.0)/n1;
      b1=pitch_cena[0]-tangens*iBarShift(Symbol(),Period(),pitch_time[0]);

      ML_RL400(tangens, pitch_cena, pitch_time, tb1, b1, false);

      if (pitch_cena[1]>pitch_cena[2])
        {
         if (ExtUWL)
           {
            ch1=pitch_cena[1];
            tch1=pitch_time[1];
           }
         if (ExtLWL)
           {
            cl1=pitch_cena[2];
            tcl1=pitch_time[2];
           }
        }
      else
        {
         if (ExtUWL)
           {
            ch1=pitch_cena[2];
            tch1=pitch_time[2];
           }
         if (ExtLWL)
           {
            cl1=pitch_cena[1];
            tcl1=pitch_time[1];
           }
        }
//      if (fo2) {fo2=false; b1=b1+tangens;}

      if (ExtUWL)
        {
         nameObj="UWL" + ExtComplekt+"_";
         if (ExtSave)
           {
            if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
              {
               nameObj=nameObj + save;
              }
            else
              {
               if (mPitch[2]>0)
                 {
                  nameObj=nameObj + save;
                 }
              }
           }
  
         ObjectDelete(nameObj);

         ObjectCreate(nameObj,OBJ_FIBOCHANNEL,0,ta1,a1,tb1,b1,tch1,ch1);
         ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtLinePitchforkS);
         ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DOT);
         ObjectSet(nameObj,OBJPROP_RAY,false);
         ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
         ObjectSet(nameObj,OBJPROP_COLOR,CLR_NONE);
         ObjectSet(nameObj,OBJPROP_FIBOLEVELS,12);

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+0,0.146);
         ObjectSetFiboDescription(nameObj, 0, "U W L 14.6"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+1,0.236);
         ObjectSetFiboDescription(nameObj, 1, "U W L 23.6"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+2,0.382);
         ObjectSetFiboDescription(nameObj, 2, "U W L 38.2"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+3,0.5);
         ObjectSetFiboDescription(nameObj, 3, "U W L 50.0"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+4,0.618);
         ObjectSetFiboDescription(nameObj, 4, "U W L 61.8"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+5,0.764);
         ObjectSetFiboDescription(nameObj, 5, "U W L 76.4"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+6,0.854);
         ObjectSetFiboDescription(nameObj, 6, "U W L 85.4"); 

        ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+7,1.0);
         ObjectSetFiboDescription(nameObj, 7, "U W L 100.0"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+8,1.618);
         ObjectSetFiboDescription(nameObj, 8, "U W L 161.8"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+9,2.0);
         ObjectSetFiboDescription(nameObj, 9, "U W L 200.0"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+10,2.618);
         ObjectSetFiboDescription(nameObj, 10, "U W L 261.8"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+11,4.0);
         ObjectSetFiboDescription(nameObj, 11, "U W L 400.0"); 
        }

      if (ExtLWL)
        {
         nameObj="LWL" + ExtComplekt+"_";
         if (ExtSave)
           {
            if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
              {
               nameObj=nameObj + save;
              }
            else
              {
               if (mPitch[2]>0)
                 {
                  nameObj=nameObj + save;
                 }
              }
           }

         ObjectDelete(nameObj);

         ObjectCreate(nameObj,OBJ_FIBOCHANNEL,0,ta1,a1,tb1,b1,tcl1,cl1);
         ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtLinePitchforkS);
         ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DOT);
         ObjectSet(nameObj,OBJPROP_RAY,false);
         ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
         ObjectSet(nameObj,OBJPROP_COLOR,CLR_NONE);
         ObjectSet(nameObj,OBJPROP_FIBOLEVELS,12);

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+0,0.146);
         ObjectSetFiboDescription(nameObj, 0, "L W L 14.6"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+1,0.236);
         ObjectSetFiboDescription(nameObj, 1, "L W L 23.6"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+2,0.382);
         ObjectSetFiboDescription(nameObj, 2, "L W L 38.2"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+3,0.5);
         ObjectSetFiboDescription(nameObj, 3, "L W L 50.0"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+4,0.618);
         ObjectSetFiboDescription(nameObj, 4, "L W L 61.8"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+5,0.764);
         ObjectSetFiboDescription(nameObj, 5, "L W L 76.4"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+6,0.854);
         ObjectSetFiboDescription(nameObj, 6, "L W L 85.4"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+7,1.0);
         ObjectSetFiboDescription(nameObj, 7, "L W L 100.0"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+8,1.618);
         ObjectSetFiboDescription(nameObj, 8, "L W L 161.8"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+9,2.0);
         ObjectSetFiboDescription(nameObj, 9, "L W L 200.0"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+10,2.618);
         ObjectSetFiboDescription(nameObj, 10, "L W L 261.8"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+11,4.0);
         ObjectSetFiboDescription(nameObj, 11, "L W L 400.0"); 
        }

     }

//-------------------------------------------------------

   if (ExtPitchforkStaticColor>0)
     {

      n1=iBarShift(Symbol(),Period(),pitch_time[0])-(iBarShift(Symbol(),Period(),pitch_time[1])+iBarShift(Symbol(),Period(),pitch_time[2]))/2.0;
   
      TLine=pitch_cena[1]-iBarShift(Symbol(),Period(),pitch_time[1])*(pitch_cena[0]-(pitch_cena[2]+pitch_cena[1])/2)/n1;

      nameObj="CL" + ExtComplekt+"_";
/*
      if (ExtSave)
        {
         if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
           {
            nameObj=nameObj + save;
           }
         else
           {
            if (mPitch[2]>0)
              {
               nameObj=nameObj + save;
              }
           }
        }
*/
      ObjectDelete(nameObj);

      ObjectCreate(nameObj,OBJ_CHANNEL,0,pitch_time[1],pitch_cena[1],Time[0],TLine,pitch_time[2],pitch_cena[2]);
      ObjectSet(nameObj, OBJPROP_BACK, true);
      ObjectSet(nameObj, OBJPROP_COLOR, ExtPitchforkStaticColor); 
     }
//-------------------------------------------------------

   if (ExtRLine)
     {
      n=iBarShift(Symbol(),Period(),pitch_time[0])-(iBarShift(Symbol(),Period(),pitch_time[1])+iBarShift(Symbol(),Period(),pitch_time[2]))/2.0;

      nbase1=iBarShift(Symbol(),Period(),mPitchTime[1]);
      nbase2=iBarShift(Symbol(),Period(),mPitchTime[2]);

      if (nbase1+n<=Bars)
        {
         mirror1=1;
         mirror2=0;

         ta1=Time[nbase1+n];
         tb1=Time[nbase2+n];
         tc1=mPitchTime[1];

         a1=(pitch_cena[0]-(mPitchCena[1]+mPitchCena[2])/2)+mPitchCena[1];
         b1=(pitch_cena[0]-(mPitchCena[1]+mPitchCena[2])/2)+mPitchCena[2];
         c1=mPitchCena[1];
        }
      else
        {
         mirror1=-1;
         mirror2=-1;

         ta1=mPitchTime[2];
         tb1=mPitchTime[1];
         tc1=Time[nbase2+n];

         a1=mPitchCena[2];
         b1=mPitchCena[1];
         c1=(pitch_cena[0]-(mPitchCena[1]+mPitchCena[2])/2)+mPitchCena[2];
        }

      nameObj="RLineS" + ExtComplekt+"_";
      if (ExtSave)
        {
         if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
           {
            nameObj=nameObj + save;
           }
         else
           {
            if (mPitch[2]>0)
              {
               nameObj=nameObj + save;
              }
           }
        }

      ObjectDelete(nameObj);

      ObjectCreate(nameObj,OBJ_FIBOCHANNEL,0,ta1,a1,tb1,b1,tc1,c1);

      ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtLinePitchforkS);

      if (ExtRLineBase) 
        {
         ObjectSet(nameObj,OBJPROP_COLOR,CLR_NONE);
        }
      else
        {
         ObjectSet(nameObj,OBJPROP_COLOR,ExtLinePitchforkS);
        }

      fiboRL(nameObj, mirror1, mirror2);
     }
//-------------------------------------------------------

      // ��������� ���� ����
      if (ExtFiboTime1)
        {
         nameObj="fiboTime1" + ExtComplekt+"_";
         if (ExtSave)
           {
            if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
              {
               nameObj=nameObj + save;
              }
            else
              {
               if (mPitch[2]>0)
                 {
                  nameObj=nameObj + save;
                 }
              }
           }

         ObjectDelete(nameObj);

         if (ExtPitchforkCandle)
           {
            if (!ExtPitchfork_1_HighLow)
              {
               if (mPitchCena[0]>mPitchCena[2])
                 {
                  ObjectCreate(nameObj,OBJ_FIBOTIMES,0,mPitchTime[0],mPitchCena[2]-5*Point,mPitchTime[2],mPitchCena[2]-5*Point);
                 }
               else
                 {
                  ObjectCreate(nameObj,OBJ_FIBOTIMES,0,mPitchTime[0],mPitchCena[0]-5*Point,mPitchTime[2],mPitchCena[0]-5*Point);
                 }
              }
            else
              {
               ObjectCreate(nameObj,OBJ_FIBOTIMES,0,mPitchTime[0],mPitchCena[1]-5*Point,mPitchTime[2],mPitchCena[1]-5*Point);
              }
           }
         else
           {
            if (afrl[mPitch[0]]>0)
              {
               if (afrl[mPitch[0]]>afrl[mPitch[2]])
                 {
                  ObjectCreate(nameObj,OBJ_FIBOTIMES,0,mPitchTime[0],mPitchCena[2]-5*Point,mPitchTime[2],mPitchCena[2]-5*Point);
                 }
               else
                 {
                  ObjectCreate(nameObj,OBJ_FIBOTIMES,0,mPitchTime[0],mPitchCena[0]-5*Point,mPitchTime[2],mPitchCena[0]-5*Point);
                 }
              }
            else
              {
               ObjectCreate(nameObj,OBJ_FIBOTIMES,0,mPitchTime[0],mPitchCena[1]-5*Point,mPitchTime[2],afrl[mPitch[1]]-5*Point);
              }
           }

         ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtFiboTime1C);

         fiboTime (nameObj);
        }

      if (ExtFiboTime2)
        {
         nameObj="fiboTime2" + ExtComplekt+"_";
         if (ExtSave)
           {
            if (ExtPitchforkCandle && iBarShift(Symbol(),Period(),ExtDateTimePitchfork_3)>0)
              {
               nameObj=nameObj + save;
              }
            else
              {
               if (mPitch[2]>0)
                 {
                  nameObj=nameObj + save;
                 }
              }
           }

         ObjectDelete(nameObj);

         if (ExtPitchforkCandle)
           {
            if (ExtPitchfork_1_HighLow)
              {
               ObjectCreate(nameObj,OBJ_FIBOTIMES,0,mPitchTime[1],mPitchCena[1]-8*Point,mPitchTime[2],mPitchCena[1]-8*Point);
              }
            else
              {
               ObjectCreate(nameObj,OBJ_FIBOTIMES,0,mPitchTime[1],mPitchCena[2]-8*Point,mPitchTime[2],mPitchCena[2]-8*Point);
              }
           }
         else
           {
            if (afrl[mPitch[1]]>0)
              {
               ObjectCreate(nameObj,OBJ_FIBOTIMES,0,mPitchTime[1],mPitchCena[1]-8*Point,mPitchTime[2],mPitchCena[1]-8*Point);
              }
            else
              {
               ObjectCreate(nameObj,OBJ_FIBOTIMES,0,mPitchTime[1],mPitchCena[2]-8*Point,mPitchTime[2],mPitchCena[2]-8*Point);
              }
           }

         ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtFiboTime2C);

         fiboTime (nameObj);
        }

  }
//--------------------------------------------------------
// ����� ��� ������� �����������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����-Time. ������.
//--------------------------------------------------------
void fiboTime (string nameObj)
  {
   ObjectSet(nameObj,OBJPROP_COLOR,ExtObjectColor);
//   ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DOT);
   ObjectSet(nameObj,OBJPROP_STYLE,ExtObjectStyle);
   ObjectSet(nameObj,OBJPROP_WIDTH,ExtObjectWidth);
   ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DOT);
   ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
   if (ExtFiboType==1)
     {
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,17);

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+0,0.0);
      ObjectSetFiboDescription(nameObj, 0, "0"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+1,1.0);
      ObjectSetFiboDescription(nameObj, 1, "1"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+2,1.382);
      ObjectSetFiboDescription(nameObj, 2, "Ft .382"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+3,1.5);
      ObjectSetFiboDescription(nameObj, 3, "Ft .5"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+4,1.618);
      ObjectSetFiboDescription(nameObj, 4, "Ft .618"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+5,1.707);
      ObjectSetFiboDescription(nameObj, 5, "Ft .707"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+6,1.786);
      ObjectSetFiboDescription(nameObj, 6, "Ft .786"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+7,1.886);
      ObjectSetFiboDescription(nameObj, 7, "Ft .886"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+8,2.0);
      ObjectSetFiboDescription(nameObj, 8, "Ft 1."); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+9,2.272);
      ObjectSetFiboDescription(nameObj, 9, "Ft 1.272"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+10,2.414);
      ObjectSetFiboDescription(nameObj, 10, "Ft 1.414"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+11,2.618);
      ObjectSetFiboDescription(nameObj, 11, "Ft 1.618"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+12,3.0);
      ObjectSetFiboDescription(nameObj, 12, "Ft 2."); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+13,3.414);
      ObjectSetFiboDescription(nameObj, 13, "Ft 2.414"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+15,3.618);
      ObjectSetFiboDescription(nameObj, 15, "Ft 2.618"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+16,4.0);
      ObjectSetFiboDescription(nameObj, 16, "Ft 3."); 

     }
   else
     {
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,15);

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+0,0.0);
      ObjectSetFiboDescription(nameObj, 0, "0"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+1,1.0);
      ObjectSetFiboDescription(nameObj, 1, "1"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+2,1.146);
      ObjectSetFiboDescription(nameObj, 2, "Ft .146"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+3,1.236);
      ObjectSetFiboDescription(nameObj, 3, "Ft .236"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+4,1.382);
      ObjectSetFiboDescription(nameObj, 4, "Ft .382"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+5,1.5);
      ObjectSetFiboDescription(nameObj, 5, "Ft .5"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+6,1.618);
      ObjectSetFiboDescription(nameObj, 6, "Ft .618"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+7,1.764);
      ObjectSetFiboDescription(nameObj, 7, "Ft .764"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+8,1.854);
      ObjectSetFiboDescription(nameObj, 8, "Ft .854"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+9,2.0);
      ObjectSetFiboDescription(nameObj, 9, "Ft 1."); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+10,2.236);
      ObjectSetFiboDescription(nameObj, 10, "Ft 1.236"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+11,2.618);
      ObjectSetFiboDescription(nameObj, 11, "Ft 1.618"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+12,3.0);
      ObjectSetFiboDescription(nameObj, 12, "Ft 2."); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+13,3.618);
      ObjectSetFiboDescription(nameObj, 13, "Ft 2.618"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+14,5.0);
      ObjectSetFiboDescription(nameObj, 14, "Ft 4."); 
     }
  }
//--------------------------------------------------------
// ����-Time. �����.
//--------------------------------------------------------


//--------------------------------------------------------
// ����� ��� ������� ������������. ������.
//--------------------------------------------------------
void screenPitchforkD()
  {
   int i,k1,n,nbase1,nbase2;
   double a1,b1,c1,ab1,bc1,ab2,bc2,d,n1,cena,m618=0.618,m382=0.382, tangens;
   datetime ta1,tb1,tc1,tab2,tbc2;
   bool fo1=false,fo2=false;
   int    pitch_time[]={0,0,0}; 
   double pitch_cena[]={0,0,0};
   int mirror1, mirror2;

   mPitchTime[0]=afr[2]; mPitchTime[1]=afr[1]; mPitchTime[2]=afr[0];
   mPitchCena[0]=afrx[2]; mPitchCena[1]=afrx[1]; mPitchCena[2]=afrx[0];

   cena=afrx[2]; 

   if (afrl[2]>0)
     {
      if (ExtCM_0_1A_2B_Dinamic==1)
        {
         cena=mPitchCena[0]+(mPitchCena[1]-mPitchCena[0])*ExtCM_FiboDinamic;
        }
      else if (ExtCM_0_1A_2B_Dinamic==4)
        {
         mPitchTimeSave=mPitchTime[0];
         mPitchTime[0]=mPitchTime[1];
         if (maxGipotenuza4(mPitchTime,mPitchCena))
           {
            cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m618;
           }
         else
           {
            cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m382;
           }
        }
      else if (ExtCM_0_1A_2B_Dinamic==5)
        {
         mPitchTimeSave=mPitchTime[0];
         mPitchTime[0]=mPitchTime[1];
         if (maxGipotenuza5(mPitchTime,mPitchCena))
           {
            cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m618;
           }
         else
           {
            cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*m382;
           }
        }
      else if (ExtCM_0_1A_2B_Dinamic>1)
        {
         if (ExtCM_0_1A_2B_Dinamic==2) mPitchTime[0]=mPitchTime[1];
         cena=mPitchCena[1]-(mPitchCena[1]-mPitchCena[2])*ExtCM_FiboDinamic;
        }
     }
   else
     {
      if (ExtCM_0_1A_2B_Dinamic==1)
        {
         cena=mPitchCena[0]-(mPitchCena[0]-mPitchCena[1])*ExtCM_FiboDinamic;
        }
      else if (ExtCM_0_1A_2B_Dinamic==4)
        {
         mPitchTimeSave=mPitchTime[0];
         mPitchTime[0]=mPitchTime[1];
         if (maxGipotenuza4(mPitchTime,mPitchCena))
           {
            cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m618;
           }
         else
           {
            cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m382;
           }
        }
      else if (ExtCM_0_1A_2B_Dinamic==5)
        {
         mPitchTimeSave=mPitchTime[0];
         mPitchTime[0]=mPitchTime[1];
         if (maxGipotenuza5(mPitchTime,mPitchCena))
           {
            cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m618;
           }
         else
           {
            cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*m382;
           }
        }
      else if (ExtCM_0_1A_2B_Dinamic>1)
        {
         if (ExtCM_0_1A_2B_Dinamic==2) mPitchTime[0]=mPitchTime[1];
         cena=mPitchCena[1]+(mPitchCena[2]-mPitchCena[1])*ExtCM_FiboDinamic;
        }
     }

   mPitchCena[0]=cena;

   coordinaty_1_2_mediany_AP(mPitchCena[0], mPitchCena[1], mPitchCena[2], mPitchTime[0], mPitchTime[1], mPitchTime[2], tab2, tbc2, ab1, bc1);
      
   pitch_time[0]=tab2;pitch_cena[0]=ab1;

   nameObj="pmedianaD" + ExtComplekt+"_";
   ObjectDelete(nameObj);
     
   if (ExtPitchforkDinamic==2)
     {
      ObjectCreate(nameObj,OBJ_TREND,0,tab2,ab1,tbc2,bc1);
      ObjectSet(nameObj,OBJPROP_STYLE,STYLE_DASH);
      ObjectSet(nameObj,OBJPROP_COLOR,ExtLinePitchforkD);
      ObjectSet(nameObj,OBJPROP_BACK,ExtBack);

      nameObj="1-2pmedianaD" + ExtComplekt+"_";
      ObjectDelete(nameObj);
      ObjectCreate(nameObj,OBJ_TEXT,0,tab2,ab1+3*Point);
      ObjectSetText(nameObj,"     1/2 ML",9,"Arial", ExtLinePitchforkD);
     }

   nameObj="pitchforkD" + ExtComplekt+"_";
   ObjectDelete(nameObj);

   if (ExtPitchforkDinamic!=4)
     {
      pitch_time[0]=mPitchTime[0];pitch_cena[0]=mPitchCena[0];
      if (ExtPitchforkDinamic==3) pitch_cena[0]=ab1;
     }
   pitch_time[1]=mPitchTime[1];pitch_cena[1]=mPitchCena[1];
   pitch_time[2]=mPitchTime[2];pitch_cena[2]=mPitchCena[2];

   ObjectCreate(nameObj,OBJ_PITCHFORK,0,pitch_time[0],pitch_cena[0],pitch_time[1],pitch_cena[1],pitch_time[2],pitch_cena[2]);
   if (ExtPitchforkStyle<5)
     {
      ObjectSet(nameObj,OBJPROP_STYLE,ExtPitchforkStyle);
     }
   else if(ExtPitchforkStyle<11)
     {
      ObjectSet(nameObj,OBJPROP_WIDTH,ExtPitchforkStyle-5);
     }
   ObjectSet(nameObj,OBJPROP_COLOR,ExtLinePitchforkD);
   ObjectSet(nameObj,OBJPROP_BACK,ExtBack);

   if (ExtPivotZoneDinamicColor>0 && ExtPitchforkDinamic<4) PivotZone(pitch_time, pitch_cena, ExtPivotZoneDinamicColor, "PivotZoneD");

   if (ExtFiboFanMedianaDinamicColor>0)
     {
      coordinaty_mediany_AP(pitch_cena[0], pitch_cena[1], pitch_cena[2], pitch_time[0], pitch_time[1], pitch_time[2], tb1, b1);      

      nameObj="FanMedianaDinamic" + ExtComplekt+"_";
      ObjectDelete(nameObj);

      ObjectCreate(nameObj,OBJ_FIBOFAN,0,pitch_time[0],pitch_cena[0],tb1,b1);
      ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DASH);
      ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtFiboFanMedianaDinamicColor);
      ObjectSet(nameObj,OBJPROP_BACK,ExtBack);

      if (ExtFiboType==0)
        {
         screenFibo_st();
        }
      else if (ExtFiboType==1)
        {
         screenFibo_Pesavento();
        }
      else if (ExtFiboType==2)
        {
         ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi);
         for (i=0;i<Sizefi;i++)
           {
            ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi[i]);
            ObjectSetFiboDescription(nameObj, i, fitxt100[i]); 
           }
        }
     }

   if (ExtISLDinamic)
     {
      n1=iBarShift(Symbol(),Period(),pitch_time[0])-(iBarShift(Symbol(),Period(),pitch_time[1])+iBarShift(Symbol(),Period(),pitch_time[2]))/2.0;
      ta1=pitch_time[1];
      a1=pitch_cena[1];
      tangens=(pitch_cena[0]-(pitch_cena[1]+pitch_cena[2])/2.0)/n1;

      ML_RL400(tangens, pitch_cena, pitch_time, tb1, b1, true);

      tc1=pitch_time[2];
      c1=pitch_cena[2];

      nameObj="ISL_D" + ExtComplekt+"_";

      ObjectDelete(nameObj);

      ObjectCreate(nameObj,OBJ_FIBOCHANNEL,0,ta1,a1,tb1,b1,tc1,c1);
      ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtLinePitchforkD);
      ObjectSet(nameObj,OBJPROP_LEVELSTYLE,ExtPitchforkStyle);
      ObjectSet(nameObj,OBJPROP_RAY,false);
      ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
      ObjectSet(nameObj,OBJPROP_COLOR,CLR_NONE);
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,6);

      if (ExtFiboType==1)
        {
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+0,-0.886);
         ObjectSetFiboDescription(nameObj, 0, "   I S L 88.6"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+1,-0.786);
         ObjectSetFiboDescription(nameObj, 1, "    I S L 78.6"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+2,-0.618);
         ObjectSetFiboDescription(nameObj, 2, "    I S L 61.8"); 
        }
      else
        {
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+0,-0.854);
         ObjectSetFiboDescription(nameObj, 0, "   I S L 85.4"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+1,-0.764);
         ObjectSetFiboDescription(nameObj, 1, "    I S L 76.4"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+2,-0.618);
         ObjectSetFiboDescription(nameObj, 2, "    I S L 61.8"); 
        }

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+3,-0.382);
      ObjectSetFiboDescription(nameObj, 3, "    I S L 38.2"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+4,-0.236);
      ObjectSetFiboDescription(nameObj, 4, "    I S L 23.6"); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+5,-0.146);
      ObjectSetFiboDescription(nameObj, 5, "    I S L 14.6"); 
     }

   if (ExtRLine)
     {
      n=iBarShift(Symbol(),Period(),pitch_time[0])-(iBarShift(Symbol(),Period(),pitch_time[1])+iBarShift(Symbol(),Period(),pitch_time[2]))/2.0;
   
      nbase1=iBarShift(Symbol(),Period(),pitch_time[1]);
      nbase2=iBarShift(Symbol(),Period(),pitch_time[2]);

      if (nbase1+n<=Bars)
        {
         mirror1=1;
         mirror2=0;

         ta1=Time[nbase1+n];
         tb1=Time[nbase2+n];
         tc1=mPitchTime[1];

         a1=(pitch_cena[0]-(mPitchCena[1]+mPitchCena[2])/2)+mPitchCena[1];
         b1=(pitch_cena[0]-(mPitchCena[1]+mPitchCena[2])/2)+mPitchCena[2];
         c1=mPitchCena[1];
        }
      else
        {
         mirror1=-1;
         mirror2=-1;

         ta1=mPitchTime[2];
         tb1=mPitchTime[1];
         tc1=Time[nbase2+n];

         a1=mPitchCena[2];
         b1=mPitchCena[1];
         c1=(pitch_cena[0]-(mPitchCena[1]+mPitchCena[2])/2)+mPitchCena[2];
        }

      nameObj="RLineD" + ExtComplekt+"_";
      ObjectDelete(nameObj);

      ObjectCreate(nameObj,OBJ_FIBOCHANNEL,0,ta1,a1,tb1,b1,tc1,c1);

      ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtLinePitchforkD);

      if (ExtRLineBase) 
        {
         ObjectSet(nameObj,OBJPROP_COLOR,CLR_NONE);
        }
      else
        {
         ObjectSet(nameObj,OBJPROP_COLOR,ExtLinePitchforkD);
        }

      fiboRL(nameObj, mirror1, mirror2);
     }
  }
//--------------------------------------------------------
// ����� ��� ������� ������������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ���� ��� RLine. �����.
//--------------------------------------------------------
void fiboRL(string nameObj, int mirror1, int mirror2)
  {
      ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DOT);
      ObjectSet(nameObj,OBJPROP_RAY,false);
      ObjectSet(nameObj,OBJPROP_BACK,ExtBack);

      if (ExtFiboType==1)
        {
         ObjectSet(nameObj,OBJPROP_FIBOLEVELS,15);

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+0,mirror2+mirror1*0.382);
         ObjectSetFiboDescription(nameObj, 0, " RL 38.2"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+1,mirror2+mirror1*0.5);
         ObjectSetFiboDescription(nameObj, 1, " RL 50.0"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+2,mirror2+mirror1*0.618);
         ObjectSetFiboDescription(nameObj, 2, " RL 61.8"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+3,mirror2+mirror1*0.707);
         ObjectSetFiboDescription(nameObj, 3, " RL 70.7"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+4,mirror2+mirror1*0.786);
         ObjectSetFiboDescription(nameObj, 4, " RL 78.6"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+5,mirror2+mirror1*0.886);
         ObjectSetFiboDescription(nameObj, 5, " RL 88.6"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+6,mirror2+mirror1*1.0);
         ObjectSetFiboDescription(nameObj, 6, " RL 100.0"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+7,mirror2+mirror1*1.128);
         ObjectSetFiboDescription(nameObj, 7, " RL 112.8"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+8,mirror2+mirror1*1.272);
         ObjectSetFiboDescription(nameObj, 8, " RL 127.2"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+9,mirror2+mirror1*1.414);
         ObjectSetFiboDescription(nameObj, 9, " RL 141.4"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+10,mirror2+mirror1*1.618);
         ObjectSetFiboDescription(nameObj, 10, " RL 161.8"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+11,mirror2+mirror1*2.0);
         ObjectSetFiboDescription(nameObj, 11, " RL 200.0"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+12,mirror2+mirror1*2.414);
         ObjectSetFiboDescription(nameObj, 12, " RL 241.4"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+13,mirror2+mirror1*2.618);
         ObjectSetFiboDescription(nameObj, 13, " RL 261.8"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+14,mirror2+mirror1*4.0);
         ObjectSetFiboDescription(nameObj, 14, " RL 400.0"); 

        }
      else
        {
         ObjectSet(nameObj,OBJPROP_FIBOLEVELS,12);

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+0,mirror2+mirror1*0.236);
         ObjectSetFiboDescription(nameObj, 0, " RL 23.6"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+1,mirror2+mirror1*0.382);
         ObjectSetFiboDescription(nameObj, 1, " RL 38.2"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+2,mirror2+mirror1*0.5);
         ObjectSetFiboDescription(nameObj, 2, " RL 50.0"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+3,mirror2+mirror1*0.618);
         ObjectSetFiboDescription(nameObj, 3, " RL 61.8"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+4,mirror2+mirror1*0.764);
         ObjectSetFiboDescription(nameObj, 4, " RL 76.4"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+5,mirror2+mirror1*0.854);
         ObjectSetFiboDescription(nameObj, 5, " RL 85.4"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+6,mirror2+mirror1*1.0);
         ObjectSetFiboDescription(nameObj, 6, " RL 100.0"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+7,mirror2+mirror1*1.236);
         ObjectSetFiboDescription(nameObj, 7, " RL 123.6"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+8,mirror2+mirror1*1.618);
         ObjectSetFiboDescription(nameObj, 8, " RL 161.8"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+9,mirror2+mirror1*2.0);
         ObjectSetFiboDescription(nameObj, 9, " RL 200"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+10,mirror2+mirror1*2.618);
         ObjectSetFiboDescription(nameObj, 10, " RL 261.8"); 

         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+11,mirror2+mirror1*4.0);
         ObjectSetFiboDescription(nameObj, 11, " RL 400.0"); 
        }
  }
//--------------------------------------------------------
// ���� ��� RLine. �����.
//--------------------------------------------------------


//--------------------------------------------------------
// ������������ ������� ��������� 1/2 ������� ��� �������. ������.
//--------------------------------------------------------
// ������������ ��������� ���� � ����� ���� ����� ��� �������
// � ����� ������ �� ���������� - 
// tAB2, tBC2 - ����� �����, ����� ������� ���������� 1/2 �������
// AB2, BC2 - ������� �������� �����, ����� ������� ���������� 1/2 �������
// 
void coordinaty_1_2_mediany_AP(double A_1, double B_2, double C_3, datetime T_1, datetime T_2, datetime T_3, datetime& tAB2, datetime& tBC2, double& AB2, double& BC2)
  {
   double tangens;
   int    n1, n2, n3, nab2, nbc2;
   
   // ������ �����, �� ������� �������� ���� �������
   n1=iBarShift(Symbol(),Period(),T_1);
   n2=iBarShift(Symbol(),Period(),T_2);
   n3=iBarShift(Symbol(),Period(),T_3);
   
   // ������� ���� ������� 1/2 ������� ��� �������
   tangens=(C_3 - A_1)/(n1 - n3);
   // ������ �����, ����� ������� ����� ��������� 1/2 �������
   nab2=MathCeil((n1+n2)/2.0);
   nbc2=MathCeil((n2+n3)/2.0);
   
   // �������� ���� �����, ����� ������� ����� ��������� 1/2 �������
   AB2=(A_1 + B_2)/2 - (nab2-(n1+n2)/2.0)*tangens;
   BC2=(B_2 + C_3)/2 - (nbc2-(n2+n3)/2.0)*tangens;
   // ����� �����, ����� ������� ����� ��������� 1/2 �������
   tAB2=Time[nab2];
   tBC2=Time[nbc2];
  }
//--------------------------------------------------------
// ������������ ������� ��������� 1/2 ������� ��� �������. �����.
//--------------------------------------------------------


//--------------------------------------------------------
// ������������ ������� ���������� ����� �� ������� ��� �������. ������.
//--------------------------------------------------------
// ������������ ��������� ���� � ����� ���� ����� ��� �������
// � ����� ������ �� ���������� - 
// tAB2, tBC2 - ����� �����, ����� ������� ���������� 1/2 �������
// AB2, BC2 - ������� �������� �����, ����� ������� ���������� 1/2 �������
// 
void coordinaty_mediany_AP(double A_1, double B_2, double C_3, datetime T_1, datetime T_2, datetime T_3, datetime& tB1, double& B1)
  {
   double tangens;
   int    n1, n2, n3, nbc2;
   
   // ������ �����, �� ������� �������� ���� �������
   n1=iBarShift(Symbol(),Period(),T_1);
   n2=iBarShift(Symbol(),Period(),T_2);
   n3=iBarShift(Symbol(),Period(),T_3);
   
   // ������� ���� ������� ������� ��� �������
   tangens=(A_1-(C_3+B_2)/2)/(n1 - (n3+n2)/2.0);
   // ����� ����, ����� ������� �������� �������
   nbc2=MathCeil((n2+n3)/2.0);

   // �������� ���� �����, ����� ������� �������� �������
   B1=(B_2 + C_3)/2 - ((n2+n3)/2.0-nbc2)*tangens;

   // ����� ����, ����� ������� �������� �������
   tB1=Time[nbc2];
  }
//--------------------------------------------------------
// ������������ ������� ���������� ����� �� ������� ��� �������. �����.
//--------------------------------------------------------


//--------------------------------------------------------
// ��������� ��������� ��� ExtCM_0_1A_2B=4. ������.
//-------------------------------------------------------
bool maxGipotenuza4(datetime &pitch_time1[], double &pitch_cena1[])
  {
   double k2,k3;
   datetime k4,k5;
/*
   k2=MathAbs(pitch_cena1[0]-pitch_cena1[1])/Point;
   k3=MathAbs(pitch_cena1[1]-pitch_cena1[2])/Point;
   k4=(mPitchTimeSave-pitch_time1[1])/(GrossPeriod*60);
   k5=(pitch_time1[1]-pitch_time1[2])/(GrossPeriod*60);
*/
   k2=MathAbs(pitch_cena1[0]-pitch_cena1[1])/ASBar;
   k3=MathAbs(pitch_cena1[1]-pitch_cena1[2])/ASBar;
   k4=iBarShift(NULL,GrossPeriod,mPitchTimeSave)-iBarShift(NULL,GrossPeriod,pitch_time1[1]);
   k5=iBarShift(NULL,GrossPeriod,pitch_time1[1])-iBarShift(NULL,GrossPeriod,pitch_time1[2]);

   if (k2*k2+k4*k4>k3*k3+k5*k5) return(true); else return(false);
  }
//--------------------------------------------------------
// ��������� ��������� ��� ExtCM_0_1A_2B=4. �����.
//-------------------------------------------------------


//--------------------------------------------------------
// ��������� ��������� ��� ExtCM_0_1A_2B=5. ������.
//-------------------------------------------------------
bool maxGipotenuza5(datetime &pitch_time1[], double &pitch_cena1[])
  {
   double k2,k3;
   datetime k4,k5;

   k2=MathAbs(pitch_cena1[0]-pitch_cena1[1])/Point;
   k3=MathAbs(pitch_cena1[1]-pitch_cena1[2])/Point;
   k4=iBarShift(NULL,GrossPeriod,mPitchTimeSave)-iBarShift(NULL,GrossPeriod,pitch_time1[1]);
   k5=iBarShift(NULL,GrossPeriod,pitch_time1[1])-iBarShift(NULL,GrossPeriod,pitch_time1[2]);

   if (k2*k2+k4*k4>k3*k3+k5*k5) return(true); else return(false);
  }
//--------------------------------------------------------
// ��������� ��������� ��� ExtCM_0_1A_2B=5. �����.
//-------------------------------------------------------


//--------------------------------------------------------
// Pivot Zone. ������.
//-------------------------------------------------------
void PivotZone(datetime pitch_time1[], double pitch_cena1[], color PivotZoneColor, string name)
  {
   datetime ta1, tb1;
   double a1, b1, d, n1;
   int m, m1, m2;
  
   ta1=pitch_time1[2];
   a1=pitch_cena1[2];
   m1=iBarShift(Symbol(),Period(),pitch_time1[0])-iBarShift(Symbol(),Period(),pitch_time1[1]);
   m2=iBarShift(Symbol(),Period(),pitch_time1[1])-iBarShift(Symbol(),Period(),pitch_time1[2]);
   m=iBarShift(Symbol(),Period(),pitch_time1[2]);
   n1=iBarShift(Symbol(),Period(),pitch_time1[0])-(iBarShift(Symbol(),Period(),pitch_time1[1])+iBarShift(Symbol(),Period(),pitch_time1[2]))/2.0;
   d=(pitch_cena1[0]-(pitch_cena1[1]+pitch_cena1[2])/2.0)/n1;

   if (m1>m2)
     {
      if (m1>m)
        {
         tb1=Time[0]+(m1-m)*Period()*60;
        }
      else
        {
         tb1=Time[iBarShift(Symbol(),Period(),pitch_time1[2])-m1];
        }
      b1=pitch_cena1[0]-d*(2*m1+m2);
     }
   else
     {
      if (m2>m)
        {
         tb1=Time[0]+(m2-m)*Period()*60;
        }
      else
        {
         tb1=Time[iBarShift(Symbol(),Period(),pitch_time1[2])-m2];
        }
      b1=pitch_cena1[0]-d*(2*m2+m1);
     }

   nameObj=name + ExtComplekt+"_";
   ObjectDelete(nameObj);

   ObjectCreate(nameObj,OBJ_RECTANGLE,0,ta1,a1,tb1,b1);
   ObjectSetText(nameObj,"PZ "+Period_tf+"  "+TimeToStr(tb1,TIME_DATE|TIME_MINUTES));
   ObjectSet(nameObj, OBJPROP_BACK, ExtPivotZoneFramework);
   ObjectSet(nameObj, OBJPROP_COLOR, PivotZoneColor); 
  }
//--------------------------------------------------------
// Pivot Zone. �����.
//-------------------------------------------------------

//--------------------------------------------------------
// ����������� ����� ����������� RL400 �������. ������.
//-------------------------------------------------------
// flag=true - �������������� ISL
// flag=false - �������������� UWL/LWL
void ML_RL400(double Tangens, double pitch_cena1[], datetime pitch_time1[], int& tB1, double& B1, bool flag)
  {
   int m, m1, m2;
  
   m1=iBarShift(Symbol(),Period(),pitch_time1[0]);
   m2=MathCeil((iBarShift(Symbol(),Period(),pitch_time1[1])+iBarShift(Symbol(),Period(),pitch_time1[2]))/2.0);
   m=(m1-m2)*4;

   if (m>m2)
     {
      tB1=Time[0]+(m-m2)*Period()*60;
      if (tB1<0) tB1=2133648000;
      if (flag) B1=pitch_cena1[1]-Tangens*(iBarShift(Symbol(),Period(),pitch_time1[1])+(tB1-Time[0])/(60*Period()));
      else  B1=pitch_cena1[0]-Tangens*(iBarShift(Symbol(),Period(),pitch_time1[0])+(tB1-Time[0])/(60*Period()));
     }
   else
     {
      tB1=Time[m2-m];
      if (flag) B1=pitch_cena1[1]-Tangens*(iBarShift(Symbol(),Period(),pitch_time1[1])-iBarShift(Symbol(),Period(),tB1));
      else  B1=pitch_cena1[0]-Tangens*(iBarShift(Symbol(),Period(),pitch_time1[0])-iBarShift(Symbol(),Period(),tB1));
     }
  }
//--------------------------------------------------------
// ����������� ����� ����������� RL400 �������. �����.
//-------------------------------------------------------


//--------------------------------------------------------
// ����� ������������ ����������. ������.
//--------------------------------------------------------
void screenFiboFan()
  {
   int i;
   double a1,b1;  

   a1=afrx[mFan[0]]; b1=afrx[mFan[1]];
  
   nameObj="FiboFan" + ExtComplekt+"_";

   if (mFan[1]>0)
     {
      if (ExtSave)
        {
         nameObj=nameObj + save;
        }
     }

   ObjectDelete(nameObj);

   ObjectCreate(nameObj,OBJ_FIBOFAN,0,afr[mFan[0]],a1,afr[mFan[1]],b1);
   ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DASH);
   ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtFiboFanColor);
   ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
   ObjectSet(nameObj,OBJPROP_COLOR,ExtObjectColor);
   ObjectSet(nameObj,OBJPROP_STYLE,ExtObjectStyle);
   ObjectSet(nameObj,OBJPROP_WIDTH,ExtObjectWidth);

   if (ExtFiboType==0)
     {
      screenFibo_st();
     }
   else if (ExtFiboType==1)
     {
      screenFibo_Pesavento();
     }
   else if (ExtFiboType==2)
     {
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi);
      for (i=0;i<Sizefi;i++)
        {
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi[i]);
         ObjectSetFiboDescription(nameObj, i, fitxt100[i]); 
        }
     }

  }
//--------------------------------------------------------
// ����� ������������ ����������. �����.
//--------------------------------------------------------


//--------------------------------------------------------
// ������ ����������� ��� ��� ������������ ������. ������.
//--------------------------------------------------------
void screenFibo_st()
  {
   double   fi_1[]={0.236, 0.382, 0.5, 0.618, 0.764, 0.854, 1.0, 1.618, 2.618};
   string   fitxt100_1[]={"23.6", "38.2", "50.0", "61.8", "76.4", "85.4", "100.0", "161.8", "2.618"};
   int i;
   Sizefi_1=9;

   ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1);
   for (i=0;i<Sizefi_1;i++)
     {
      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi_1[i]);
      ObjectSetFiboDescription(nameObj, i, fitxt100_1[i]); 
     }
  }
//--------------------------------------------------------
// ������ ����������� ��� ��� ������������ ������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ������ ��� ��������� ��� ������������ ������. ������.
//--------------------------------------------------------
void screenFibo_Pesavento()
  {
   double   fi_1[]={0.382, 0.5, 0.618, 0.786, 0.886, 1.0, 1.272, 1.618, 2.0, 2.618};
   string   fitxt100_1[]={"38.2", "50.0", "61.8", "78.6", "88.6", "100.0", "127.2", "161.8", "200.0", "2.618"};
   int i;
   Sizefi_1=10;

   ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1);
   for (i=0;i<Sizefi_1;i++)
     {
      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi_1[i]);
      ObjectSetFiboDescription(nameObj, i, fitxt100_1[i]); 
     }
  }
//--------------------------------------------------------
// ������ ��� ��������� ��� ������������ ������. �����.
//--------------------------------------------------------



//--------------------------------------------------------
// ����� ��� �����������. ������.
//--------------------------------------------------------
void screenFiboS()
  {
   nameObj="fiboS" + ExtComplekt+"_";
   if (mFibo[1]>0)
     {
      if (ExtSave)
        {
         nameObj=nameObj + save;
        }
     }

   screenFibo_(ExtFiboS, "                             ", mFibo[0], mFibo[1]);
  }
//--------------------------------------------------------
// ����� ��� �����������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ��� ������������. ������.
//--------------------------------------------------------
void screenFiboD()
  {
   nameObj="fiboD" + ExtComplekt+"_";
   screenFibo_(ExtFiboD, "", 1, 0);
  }
//--------------------------------------------------------
// ����� ��� ������������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ���. ������.
//--------------------------------------------------------
void screenFibo_(color colorFibo, string otstup, int a1, int a2)
  {
   double fibo_0, fibo_100, fiboPrice, fiboPrice1;

   ObjectDelete(nameObj);

   if (!ExtFiboCorrectionExpansion)
     {
      fibo_0=afrx[a1];fibo_100=afrx[a2];
      fiboPrice=afrx[a1]-afrx[a2];fiboPrice1=afrx[a2];
     }
   else
     {
      fibo_100=afrx[a1];fibo_0=afrx[a2];
      fiboPrice=afrx[a2]-afrx[a1];fiboPrice1=afrx[a1];
     }

   if (!ExtFiboCorrectionExpansion)
     {
      ObjectCreate(nameObj,OBJ_FIBO,0,afr[a1],fibo_0,afr[a2],fibo_100);
     }
   else
     {
      ObjectCreate(nameObj,OBJ_FIBO,0,afr[a2],fibo_0,afr[a1],fibo_100);
     }

   ObjectSet(nameObj,OBJPROP_LEVELCOLOR,colorFibo);

   ObjectSet(nameObj,OBJPROP_COLOR,ExtObjectColor);
   ObjectSet(nameObj,OBJPROP_STYLE,ExtObjectStyle);
   ObjectSet(nameObj,OBJPROP_WIDTH,ExtObjectWidth);
   ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DOT);
   ObjectSet(nameObj,OBJPROP_BACK,ExtBack);

   if (ExtFiboType==0)
     {
      fibo_standart (fiboPrice, fiboPrice1,"-"+Period_tf+otstup);
     }
   else if (ExtFiboType==1)
     {
      fibo_patterns(fiboPrice, fiboPrice1,"-"+Period_tf+otstup);
     }
   else if (ExtFiboType==2)
     {
      fibo_custom (fiboPrice, fiboPrice1,"-"+Period_tf+otstup);
     }
  }
//--------------------------------------------------------
// �������� ���. �����.
//--------------------------------------------------------


//--------------------------------------------------------
// ���� �����������. ������.
//--------------------------------------------------------
void fibo_standart(double fiboPrice,double fiboPrice1,string fibo)
  {
   double   fi_1[]={0, 0.146, 0.236, 0.382, 0.5, 0.618, 0.764, 0.854, 1.0, 1.236, 1.618, 2.618, 4.236, 6.854};
   string   fitxt100_1[]={"0.0", "14.6", "23.6", "38.2", "50.0", "61.8", "76.4", "85.4", "100.0", "123.6", "161.8", "2.618", "423.6", "685.4"};
   int i;
   Sizefi_1=14;

   if (!ExtFiboCorrectionExpansion)
     {   
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1);
      for (i=0;i<Sizefi_1;i++)
        {
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi_1[i]);
         ObjectSetFiboDescription(nameObj, i, fitxt100_1[i]+" "+DoubleToStr(fiboPrice*fi_1[i]+fiboPrice1, Digits)+fibo); 
        }
     }
   else
     {
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1+2);

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL,0);
      ObjectSetFiboDescription(nameObj, 0, "Fe 1 "+DoubleToStr(fiboPrice+fiboPrice1, Digits)+fibo); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL,1);
      ObjectSetFiboDescription(nameObj, 1, "Fe 0 "+DoubleToStr(fiboPrice1, Digits)+fibo); 

      for (i=0;i<Sizefi_1;i++)
        {
         if (fi_1[i]>0)
           {
            ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i+2,1+fi_1[i]);
            ObjectSetFiboDescription(nameObj, i+2, "Fe "+fitxt100_1[i]+" "+DoubleToStr(fiboPrice*fi_1[i]+fiboPrice1, Digits)+fibo); 
           }
        }
     }
  }
//--------------------------------------------------------
// ���� �����������. �����.
//--------------------------------------------------------


//--------------------------------------------------------
// ���� � ����������. ������.
//--------------------------------------------------------
void fibo_patterns(double fiboPrice,double fiboPrice1,string fibo)
  {
   double   fi_1[]={0.0, 0.382, 0.447, 0.5, 0.618, 0.707, 0.786, 0.854, 0.886, 1.0, 1.128, 1.272, 1.414, 1.618, 2.0, 2.618, 4.0};
   string   fitxt100_1[]={"0.0", "38.2", "44.7", "50.0", "61.8", "70.7", "78.6", "85.4", "88.6", "100.0", "112.8", "127.2", "141.4", "161.8", "200.0", "261.8", "400.0"};
   int i;
   Sizefi_1=17;

   if (!ExtFiboCorrectionExpansion)
     {   
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1);
      for (i=0;i<Sizefi_1;i++)
        {
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi_1[i]);
         ObjectSetFiboDescription(nameObj, i, fitxt100_1[i]+" "+DoubleToStr(fiboPrice*fi_1[i]+fiboPrice1, Digits)+fibo); 
        }
     }
   else
     {
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1+2);

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL,0);
      ObjectSetFiboDescription(nameObj, 0, "Fe 1 "+DoubleToStr(fiboPrice+fiboPrice1, Digits)+fibo); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL,1);
      ObjectSetFiboDescription(nameObj, 1, "Fe 0 "+DoubleToStr(fiboPrice1, Digits)+fibo); 

      for (i=0;i<Sizefi_1;i++)
        {
         if (fi_1[i]>0)
           {
            ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i+2,1+fi_1[i]);
            ObjectSetFiboDescription(nameObj, i+2, "Fe "+fitxt100_1[i]+" "+DoubleToStr(fiboPrice*fi_1[i]+fiboPrice1, Digits)+fibo); 
           }
        }
     }
  }
//--------------------------------------------------------
// ���� � ����������. �����.
//--------------------------------------------------------


//--------------------------------------------------------
// ���� ����������������. ������.
//--------------------------------------------------------
void fibo_custom(double fiboPrice,double fiboPrice1,string fibo)
  {
   int i;

   if (!ExtFiboCorrectionExpansion)
     {   
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi);
      for (i=0;i<Sizefi;i++)
        {
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi[i]);
         ObjectSetFiboDescription(nameObj, i, fitxt100[i]+" "+DoubleToStr(fiboPrice*fi[i]+fiboPrice1, Digits)+fibo); 
        }
     }
   else
     {
      ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi+2);

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL,0);
      ObjectSetFiboDescription(nameObj, 0, "Fe 1 "+DoubleToStr(fiboPrice+fiboPrice1, Digits)+fibo); 

      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL,1);
      ObjectSetFiboDescription(nameObj, 1, "Fe 0 "+DoubleToStr(fiboPrice1, Digits)+fibo); 

      for (i=0;i<Sizefi;i++)
        {
         if (fi[i]>0)
           {
            ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i+2,1+fi[i]);
            ObjectSetFiboDescription(nameObj, i+2, "Fe "+fitxt100[i]+" "+DoubleToStr(fiboPrice*fi[i]+fiboPrice1, Digits)+fibo); 
           }
        }
     }
  }
//--------------------------------------------------------
// ���� ����������������. �����.
//--------------------------------------------------------


//--------------------------------------------------------
// ����� ����-��� �����������. ������.
//--------------------------------------------------------
void screenFiboArcS()
  {
   double fibo_0, fibo_100, AutoScale;

   fibo_0=afrx[mArcS[0]];fibo_100=afrx[mArcS[1]];

   if (ExtArcStaticScale>0)
     {
      AutoScale=ExtArcStaticScale;
     }
   else
     {
      AutoScale=(MathAbs(fibo_0-fibo_100)/Point)/MathAbs(iBarShift(Symbol(),Period(),afr[mArcS[1]])-iBarShift(Symbol(),Period(),afr[mArcS[0]]));
     }

   nameObj="FiboArcS" + ExtComplekt+"_";
   if (ExtSave)
     {
      nameObj=nameObj + save;
     }
   ObjectDelete(nameObj);

   ObjectCreate(nameObj,OBJ_FIBOARC,0,afr[mArcS[0]],fibo_0,afr[mArcS[1]],fibo_100);

   fiboArc(AutoScale, ExtArcStaticColor);
  }
//--------------------------------------------------------
// ����� ����-��� �����������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ����-��� ������������. ������.
//--------------------------------------------------------
void screenFiboArcD()
  {
   double fibo_0, fibo_100, AutoScale;

   fibo_0=afrx[mArcD[0]];fibo_100=afrx[mArcD[1]];

   if (ExtArcDinamicScale>0)
     {
      AutoScale=ExtArcDinamicScale;
     }
   else
     {
      AutoScale=(MathAbs(fibo_0-fibo_100)/Point)/MathAbs(iBarShift(Symbol(),Period(),afr[mArcD[1]])-iBarShift(Symbol(),Period(),afr[mArcD[0]]));
     }

   nameObj="FiboArcD" + ExtComplekt+"_";

   ObjectDelete(nameObj);

   ObjectCreate(nameObj, OBJ_FIBOARC,0,afr[mArcD[0]],fibo_0,afr[mArcD[1]],fibo_100);

   fiboArc(AutoScale, ExtArcDinamicColor);
  }
//--------------------------------------------------------
// ����� ����-��� ������������. �����.
//--------------------------------------------------------


//--------------------------------------------------------
// ���� ��� ����-���. ������.
//--------------------------------------------------------
void fiboArc(double AutoScale, color ArcColor)
  {
   ObjectSet(nameObj,OBJPROP_SCALE,AutoScale);
   ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
   ObjectSet(nameObj,OBJPROP_COLOR,ExtObjectColor);
   ObjectSet(nameObj,OBJPROP_STYLE,ExtObjectStyle);
   ObjectSet(nameObj,OBJPROP_WIDTH,ExtObjectWidth);
   ObjectSet(nameObj,OBJPROP_ELLIPSE,true);
   ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ArcColor);
//   ObjectSet(nameObj,OBJPROP_LEVELSTYLE,ExtArcStyle);
//   ObjectSet(nameObj,OBJPROP_LEVELWIDTH,ExtArcWidth);


   if (ExtFiboType==0)
     {
      fiboArc_st();
     }
   else if (ExtFiboType==1)
     {
      fiboArc_Pesavento();
     }
   else if (ExtFiboType==2)
     {
      fiboArc_custom();
     }
  }
//--------------------------------------------------------
// ���� ��� ����-���. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ���� ��� ����������� ����-���. ������.
//--------------------------------------------------------
void fiboArc_st()
  {
   double   fi_1[]={0.0, 0.146, 0.236, 0.382, 0.5, 0.618, 0.764, 0.854, 1.0, 1.236, 1.618, 2.0, 2.618, 3.0, 4.236, 4.618};
   string   fitxt100_1[]={"0.0", "14.6", "23.6", "38.2", "50.0", "61.8", "76.4", "85.4", "100.0", "123.6", "161.8", "200.0", "261.8", "300.0", "423.6", "461.8"};
   int i;
   Sizefi_1=16;

   ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1);
   for (i=0;i<Sizefi_1;i++)
     {
      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi_1[i]);
      ObjectSetFiboDescription(nameObj,i,fitxt100_1[i]);
     }
  }
//--------------------------------------------------------
// ���� ��� ����������� ����-���. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ���� ��� ����-��� � ������� ���������. ������.
//--------------------------------------------------------
void fiboArc_Pesavento()
  {
   double   fi_1[]={0.0, 0.146, 0.236, 0.382, 0.5, 0.618, 0.786, 0.886, 1.0, 1.272, 1.618, 2.0, 2.618, 3.0, 4.236, 4.618};
   string   fitxt100_1[]={"0.0", "14.6", "23.6", "38.2", "50.0", "61.8", "78.6", "88.6", "100.0", "127.2", "161.8", "200.0", "261.8", "300.0", "423.6", "461.8"};
   int i;
   Sizefi_1=16;

   ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1);
   for (i=0;i<Sizefi_1;i++)
     {
      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi_1[i]);
      ObjectSetFiboDescription(nameObj,i,fitxt100_1[i]);
     }
  }
//--------------------------------------------------------
// ���� ��� ����-��� � ������� ���������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ���� ��� ���������������� ����-���. ������.
//--------------------------------------------------------
void fiboArc_custom()
  {
   int i;

   ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi);
   for (i=0;i<Sizefi;i++)
     {
      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi[i]);
      ObjectSetFiboDescription(nameObj,i,fitxt100[i]);
     }
  }
//--------------------------------------------------------
// ���� ��� ���������������� ����-���. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ����-������ �����������. ������.
//--------------------------------------------------------
void screenFiboFanS()
  {
   double fiboPrice1, fiboPrice2;

   nameObj="fiboFanS" + ExtComplekt+"_";
   ObjectDelete(nameObj);

   if (ExtPitchforkCandle)
     {
      if (ExtPitchfork_1_HighLow)
        {
         fiboPrice1=mPitchCena[1];fiboPrice2=mPitchCena[2];
        }
      else 
        {
         fiboPrice1=mPitchCena[1];fiboPrice2=mPitchCena[2];
        }
      ObjectCreate(nameObj,OBJ_FIBOFAN,0,mPitchTime[1],fiboPrice1,mPitchTime[2],fiboPrice2);
     }
   else
     {
      if (afrl[mPitch[1]]>0) 
        {
         fiboPrice1=afrl[mPitch[1]];fiboPrice2=afrh[mPitch[2]];
        }
      else 
        {
         fiboPrice1=afrh[mPitch[1]];fiboPrice2=afrl[mPitch[2]];
        }
      ObjectCreate(nameObj,OBJ_FIBOFAN,0,afr[mPitch[1]],fiboPrice1,afr[mPitch[2]],fiboPrice2);
     }

   ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtFiboFanS);

   FiboFanLevel();

  }
//--------------------------------------------------------
// ����� ����-������ �����������. �����.
//--------------------------------------------------------


//--------------------------------------------------------
// ����� ����-������ ������������. ������.
//--------------------------------------------------------
void screenFiboFanD()
  {
   double fiboPrice1, fiboPrice2;

   nameObj="fiboFanD" + ExtComplekt+"_";

   ObjectDelete(nameObj);

   fiboPrice1=afrx[1];fiboPrice2=afrx[0];

   ObjectCreate(nameObj,OBJ_FIBOFAN,0,afr[1],fiboPrice1,afr[0],fiboPrice2);
   ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtFiboFanD);

   FiboFanLevel();
  }
//--------------------------------------------------------
// ����� ����-������ ������������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ������ ����-������. �����.
//--------------------------------------------------------
void FiboFanLevel()
  {
   if(ExtFiboFanExp) ObjectSet(nameObj,OBJPROP_FIBOLEVELS,6); else ObjectSet(nameObj,OBJPROP_FIBOLEVELS,4);

   ObjectSet(nameObj,OBJPROP_COLOR,ExtObjectColor);
   ObjectSet(nameObj,OBJPROP_STYLE,ExtObjectStyle);
   ObjectSet(nameObj,OBJPROP_WIDTH,ExtObjectWidth);

   ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DASH);
   ObjectSet(nameObj,OBJPROP_BACK,ExtBack);
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+0,0.236);
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+1,0.382);
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+2,0.5);
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+3,0.618);

   if (ExtFiboFanHidden)
     {
      ObjectSetFiboDescription(nameObj, 0, "23.6"); 
      ObjectSetFiboDescription(nameObj, 1, "38.2"); 
      ObjectSetFiboDescription(nameObj, 2, "50.0"); 
      ObjectSetFiboDescription(nameObj, 3, "61.8"); 
     }
   if(ExtFiboFanExp)
     {
      if (ExtFiboType==0)
        {
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+4,0.764);
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+5,0.854);

         if (ExtFiboFanHidden)
           {
            ObjectSetFiboDescription(nameObj, 4, "76.4"); 
            ObjectSetFiboDescription(nameObj, 5, "85.4"); 
           }
        }
      else
        {
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+4,0.786);
         ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+5,0.886);

         if (ExtFiboFanHidden)
           {
            ObjectSetFiboDescription(nameObj, 4, "78.6"); 
            ObjectSetFiboDescription(nameObj, 5, "88.6"); 
           }
        }
     }
  }
//--------------------------------------------------------
//  ������ ����-������. ������.
//--------------------------------------------------------


//--------------------------------------------------------
// ����� ���������� ���������. ������.
//--------------------------------------------------------
void FiboExpansion()
  {
   if (ExtFiboExpansion>1)
     {
      int i;
      double znach1,znach2,fi_1[];

      nameObj="fiboExpansion" + ExtComplekt+"_";
      if (mExpansion[2]>0)
        {
         if (ExtSave)
           {
            nameObj=nameObj + save;
           }
        }

      ObjectDelete(nameObj);
      if (afrl[mExpansion[0]]>0)
        {
         ObjectCreate(nameObj,OBJ_EXPANSION,0,afr[mExpansion[0]],afrl[mExpansion[0]],afr[mExpansion[1]],afrh[mExpansion[1]],afr[mExpansion[2]],afrl[mExpansion[2]]);
         znach1=afrh[mExpansion[1]]-afrl[mExpansion[0]];
         znach2=afrl[mExpansion[2]];
        }
      else
        {
         ObjectCreate(nameObj,OBJ_EXPANSION,0,afr[mExpansion[0]],afrh[mExpansion[0]],afr[mExpansion[1]],afrl[mExpansion[1]],afr[mExpansion[2]],afrh[mExpansion[2]]);
         znach1=-(afrh[mExpansion[0]]-afrl[mExpansion[1]]);
         znach2=afrh[mExpansion[2]];
        }

      ObjectSet(nameObj,OBJPROP_COLOR,ExtObjectColor);
      ObjectSet(nameObj,OBJPROP_STYLE,ExtObjectStyle);
      ObjectSet(nameObj,OBJPROP_WIDTH,ExtObjectWidth);
      ObjectSet(nameObj,OBJPROP_LEVELCOLOR,ExtFiboExpansionColor);
      ObjectSet(nameObj,OBJPROP_LEVELSTYLE,STYLE_DOT);
      ObjectSet(nameObj,OBJPROP_BACK,ExtBack);

      if (ExtFiboType==0)
        {
         FiboExpansion_st(znach1, znach2);
        }
      else if (ExtFiboType==1)
        {
         FiboExpansion_Pesavento(znach1, znach2);
        }
      else if (ExtFiboType==2)
        {
         ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi);
         for (i=0;i<Sizefi;i++)
           {
            ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi[i]);
            ObjectSetFiboDescription(nameObj, i, "FE "+fitxt100[i]+" "+DoubleToStr(znach1*fi[i]+znach2, Digits)+"-"+Period_tf); 
           }
        }
     }
  }
//--------------------------------------------------------
// ����� ���������� ���������. �����.
//--------------------------------------------------------


//--------------------------------------------------------
// �������� ����������� ��� ��� ���������� ���������. ������.
//--------------------------------------------------------
void FiboExpansion_st(double znach1, double znach2)
  {
   int i;
   double fi_1[]={0.236, 0.382, 0.5, 0.618, 0.764, 0.854, 1.0, 1.236, 1.618, 2.0, 2.618};
   string tf="-"+Period_tf, fitxt100_1[]={"23.6", "38.2", "50.0", "61.8", "76.4", "85.4", "100.0", "123.6", "161.8", "200.0", "261.8"};
   Sizefi_1=11;

   ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1);
   for (i=0;i<Sizefi_1;i++)
     {
      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi_1[i]);
      ObjectSetFiboDescription(nameObj, i, "FE "+fitxt100_1[i]+" "+DoubleToStr(znach1*fi_1[i]+znach2, Digits)+tf); 
     }
  }
//--------------------------------------------------------
// �������� ����������� ��� ��� ���������� ���������. �����.
//--------------------------------------------------------


//--------------------------------------------------------
// �������� ��� ��������� ��� ���������� ���������. ������.
//--------------------------------------------------------
void FiboExpansion_Pesavento(double znach1, double znach2)
  {
   int i;
   double fi_1[]={0.382, 0.5, 0.618, 0.707, 0.786, 0.886, 1.0, 1.272, 1.414, 1.618, 2.0, 2.618, 3.0, 4.236, 4.618};
   string tf="-"+Period_tf, fitxt100_1[]={"38.2", "50.0", "61.8", "70.7", "78.6", "88.6", "100.0", "127.2", "141.4", "161.8", "200.0", "261.8", "300.0", "423.6", "461.8"};
   Sizefi_1=15;

   ObjectSet(nameObj,OBJPROP_FIBOLEVELS,Sizefi_1);
   for (i=0;i<Sizefi_1;i++)
     {
      ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+i,fi_1[i]);
      ObjectSetFiboDescription(nameObj, i, "FE "+fitxt100_1[i]+" "+DoubleToStr(znach1*fi_1[i]+znach2, Digits)+tf); 
     }
  }
//--------------------------------------------------------
// �������� ��� ��������� ��� ���������� ���������. �����.
//--------------------------------------------------------


//--------------------------------------------------------
// �������� ��������. ������.
// �������� �������������� ����� � �����.
//--------------------------------------------------------
void delete_objects1()
  {
   int i;
   string txt;

   for (i=ObjectsTotal(); i>=0; i--)
     {
      txt=ObjectName(i);
      if (StringFind(txt,"_" + ExtComplekt + "pl")>-1) ObjectDelete (txt);
      if (StringFind(txt,"_" + ExtComplekt + "ph")>-1) ObjectDelete (txt);
     }
  }
//--------------------------------------------------------
// �������� ��������. �����.
// �������� �������������� ����� � �����.
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ��������. ������.
// �������� �������������� ����� � �����.
//--------------------------------------------------------
void delete_objects2(string txt1)
  {
   int i;
   string txt;

   for (i=ObjectsTotal(); i>=0; i--)
     {
      txt=ObjectName(i);
      if (StringFind(txt,txt1)>-1)ObjectDelete (txt);
     }
  }
//--------------------------------------------------------
// �������� ��������. �����.
// �������� �������������� ����� � �����.
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ��������. ������.
// �������� ������������� � ����� ��� ����� D ��������.
//--------------------------------------------------------
void delete_objects3()
  {
   int i;
   string txt;

   for (i=ObjectsTotal(); i>=0; i--)
     {
      txt=ObjectName(i);
      if (StringFind(txt,"_"+ExtComplekt+"Triangle")>-1)ObjectDelete (txt);
     }

   if (RangeForPointD>0)
     {
      FlagForD=true;
      ObjectDelete("_"+ExtComplekt+"PointD");
     }
  }
//--------------------------------------------------------
// �������� ��������. �����.
// �������� ������������� � ����� ��� ����� D ��������.
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ������������ ��������. ������.
//--------------------------------------------------------
void delete_objects_dinamic()
  {
   int i;
   
   delete_objects1();
   ObjectDelete("fiboD" + ExtComplekt+"_");
   ObjectDelete("fiboFanD" + ExtComplekt+"_");
   ObjectDelete("RLineD" + ExtComplekt+"_");
   ObjectDelete("pitchforkD" + ExtComplekt+"_");
   ObjectDelete("ISL_D" + ExtComplekt+"_");
   ObjectDelete("pmedianaD" + ExtComplekt+"_");
   ObjectDelete("1-2pmedianaD" + ExtComplekt+"_");
   ObjectDelete("fiboExpansion" + ExtComplekt+"_");
   ObjectDelete("PivotZoneD" + ExtComplekt+"_");
   ObjectDelete("FanMedianaDinamic" + ExtComplekt+"_");
   ObjectDelete("FiboArcD" + ExtComplekt+"_");

   for (i=0; i<7; i++)
     {
      nameObj="VLD"+i+" " + ExtComplekt+"_";
      ObjectDelete(nameObj);
     }
  }
//--------------------------------------------------------
// �������� ������������ ��������. �����.
//--------------------------------------------------------



//----------------------------------------------------
//  ZigZag (�� ��4 ������� ����������). ������.
//----------------------------------------------------
void ZigZag_()
  {
//  ZigZag �� ��. ������.
   int    shift, back,lasthighpos,lastlowpos;
   double val,res;
   double curlow,curhigh,lasthigh,lastlow;
   int    vDepth = 0;
   int    Depth;
   bool   endCyklDirection=true;

   if (ExtIndicator==11)
     {
      bool     endCykl=false;
      Depth    = minDepth;
     }
   else
     {
      Depth    = minBars;
      minDepth = minBars;
      maxDepth = minBars;
     }

   if (DirectionOfSearchMaxMin) vDepth = maxDepth; else vDepth = minDepth;

   while (endCyklDirection)
     {

      if (ExtIndicator==11)
        {

         for (shift=Bars-1;shift>=0; shift--) // �������� ������������ ������
           {
            zz[shift]=0; zzL[shift]=0; zzH[shift]=0;
           }
         if (DirectionOfSearchMaxMin)
           {
            if (vDepth < minDepth) {vDepth=minBars; endCykl=true;}
           }
         else
           {
            if (vDepth > maxDepth) {vDepth=minBars; endCykl=true;}
           }

         Depth = vDepth;
         if (DirectionOfSearchMaxMin)
           {
            vDepth--;
           }
         else
           {
            vDepth++;
           }
        }
      else
        {
         endCyklDirection=false;
        }

      minBarsX=Depth;
      
      // ������ ������� ����
      for(shift=Bars-Depth; shift>=0; shift--)
        {
         val=Low[iLowest(NULL,0,MODE_LOW,Depth,shift)];
         if(val==lastlow) val=0.0;
         else 
           { 
            lastlow=val; 
            if((Low[shift]-val)>(ExtDeviation*Point)) val=0.0;
            else
              {
               for(back=1; back<=ExtBackstep; back++)
                 {
                  res=zzL[shift+back];
                  if((res!=0)&&(res>val)) zzL[shift+back]=0.0; 
                 }
              }
           } 
          if (Low[shift]==val) zzL[shift]=val;

          val=High[iHighest(NULL,0,MODE_HIGH,Depth,shift)];
          if(val==lasthigh) val=0.0;
          else 
            {
             lasthigh=val;
             if((val-High[shift])>(ExtDeviation*Point)) val=0.0;
             else
               {
                for(back=1; back<=ExtBackstep; back++)
                  {
                   res=zzH[shift+back];
                   if((res!=0)&&(res<val)) zzH[shift+back]=0.0; 
                  } 
               }
            }
          if (High[shift]==val) zzH[shift]=val;
        }

      // ������ ������� ���� 
      lasthigh=-1; lasthighpos=-1;
      lastlow=-1;  lastlowpos=-1;

      for(shift=Bars-Depth; shift>=0; shift--)
        {
         curlow=zzL[shift];
         curhigh=zzH[shift];
         if((curlow==0)&&(curhigh==0)) continue;

         if(curhigh!=0)
           {
            if(lasthigh>0) 
              {
               if(lasthigh<curhigh) zzH[lasthighpos]=0;
               else zzH[shift]=0;
              }

            if(lasthigh<curhigh || lasthigh<0)
              {
               lasthigh=curhigh;
               lasthighpos=shift;
              }
            lastlow=-1;
           }

         if(curlow!=0)
           {
            if(lastlow>0)
              {
               if(lastlow>curlow) zzL[lastlowpos]=0;
               else zzL[shift]=0;
              }

            if((curlow<lastlow)||(lastlow<0))
              {
               lastlow=curlow;
               lastlowpos=shift;
              } 
            lasthigh=-1;
           }
        }
      // ������ ������� ����
      for(shift=Bars-1; shift>=0; shift--)
        {
         zz[shift]=zzL[shift];
         if(shift>=Bars-Depth) {zzH[shift]=0.0; zzL[shift]=0.0; zz[shift]=0.0;}
         else
           {
            res=zzH[shift];
            if(res!=0.0)
              {
               zz[shift]=res;
              }
           }
        }

      NoGorb(Depth); // ������� ����� �������

      // ����� ���������
      if (ExtIndicator==11)
        {
         if (endCykl)
           {
            return(0);
           }
         _Gartley("ExtIndicator=11_" + Depth+"/"+ExtDeviation+"/"+ExtBackstep);
         if (vPatOnOff==1) return(0);
        }  // ����� ��������� �����
     }
  }
//--------------------------------------------------------
// ZigZag �� ��. �����. 
//--------------------------------------------------------


//--------------------------------------------------------
// ����������� ����������� ������ �������. ������.
//--------------------------------------------------------
void NoGorb(int Depth)
  {
   double vel1, vel2, vel3, vel4;
   int bar1, bar2, bar3, bar4;
   int count;
   for(int bar=Bars-Depth; bar>=0; bar--)
     {
      if (zz[bar]!=0)
        {
         count++;
         vel4=vel3;bar4=bar3;
         vel3=vel2;bar3=bar2;
         vel2=vel1;bar2=bar1;
         vel1=zz[bar];bar1=bar;
         if (count<3) continue; 
         if ((vel3<vel2)&&(vel2<vel1)) {zz[bar2]=0;zzL[bar2]=0;zzH[bar2]=0;bar=bar3+1;}
         if ((vel3>vel2)&&(vel2>vel1)) {zz[bar2]=0;zzL[bar2]=0;zzH[bar2]=0;bar=bar3+1;}
         if ((vel2==vel1)&&(vel1!=0 )) {zz[bar1]=0;zzL[bar1]=0;zzH[bar1]=0;bar=bar3+1;}
        }
    } 
  }
//--------------------------------------------------------
// ����������� ����������� ������ �������. �����.
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ��������� Gartley. ������.
//--------------------------------------------------------
void _Gartley(string _Depth)
  {
   int  j, k;

   double   min_DeltaGartley = (1 - ExtDeltaGartley);
   double   max_DeltaGartley = (1 + ExtDeltaGartley);
   double   vl0382 = min_DeltaGartley * 0.382;
   double   vh05   = max_DeltaGartley * 0.5;
   double   vl0618 = min_DeltaGartley * 0.618;
   double   vh0618 = max_DeltaGartley * 0.618;
   double   vl0786 = min_DeltaGartley * 0.786;
   double   vh0786 = max_DeltaGartley * 0.786;
   double   vl0886 = min_DeltaGartley * 0.886;
   double   vh0886 = max_DeltaGartley * 0.886;
   double   vl1128 = min_DeltaGartley * 1.128;
   double   vl1272 = min_DeltaGartley * 1.272;
   double   vl1618 = min_DeltaGartley * 1.618;
   double   vh1618 = max_DeltaGartley * 1.618;
   double   vl2236 = min_DeltaGartley * 2.236;
   double   vh2236 = max_DeltaGartley * 2.236;
   double   vh2618 = max_DeltaGartley * 2.618;
   double   vh3618 = max_DeltaGartley * 3.618;

   int      aXABCD[6]; // ������ ����� � ������� XABCD ���������
   double   retXD;
   double   retXB;
   double   retBD;
   double   retAC;
   double   XA, BC;
   
   double   vDelta0 = 0.000001;
   int      vNull   = 0;
   int      X=1,A=2,B=3,C=4,D=5;
   string   nameObj1, nameObj2;
   string   vBull      = "Bullish";
   string   vBear      = "Bearish";
   string   vGartley   = "Gartley";
   string   vBat       = "Bat";
   string   vButterfly = "Butterfly";
   string   vCrab      = "Crab";
   int      aNumBarPeak[];

   vPatOnOff    = 0;
   vBullBear    = "";
   vNamePattern = "";
   maxPeak      = 0;  

   for(shift=Bars-1; shift>=0; shift--)
     {
      if (zz[shift]>0) maxPeak++;
     }

   ArrayResize(aNumBarPeak, maxPeak);

   delete_objects3();

   shift = 0;
   j = 0;
   while ((shift < Bars) && (j < maxPeak))
     {
      if (zz[shift] != 0)
        {
         aNumBarPeak[j] = shift;
         j++;
        }
      shift++;
     }
   if (j<maxPeak) aNumBarPeak[j]=-1; else aNumBarPeak[maxPeak]=-1;

   aXABCD[D] = aNumBarPeak[0];
   k = 0;
   while ((k < j) && (k < maxPeak) && (aNumBarPeak[k] > -1) && (aXABCD[D] < maxBarToD+2))
     {
      aXABCD[X] = aNumBarPeak[k + 4];
      aXABCD[A] = aNumBarPeak[k + 3];
      aXABCD[B] = aNumBarPeak[k + 2];
      aXABCD[C] = aNumBarPeak[k + 1];
      aXABCD[D] = aNumBarPeak[k + 0];

      if ((zz[aXABCD[A]] > zz[aXABCD[C]]) && (zz[aXABCD[C]] > zz[aXABCD[B]]) && (zz[aXABCD[B]] > zz[aXABCD[X]]) && (zz[aXABCD[X]] > zz[aXABCD[D]]) && ((zz[aXABCD[C]] - zzL[aXABCD[D]]) >= (zz[aXABCD[A]] - zz[aXABCD[B]]) * ExtCD))
        {
         vBullBear = vBull;
        }
      else if ((zz[aXABCD[A]] > zz[aXABCD[C]]) && (zz[aXABCD[C]] > zz[aXABCD[B]]) && (zz[aXABCD[B]] > zz[aXABCD[D]]) && (zz[aXABCD[D]] > zz[aXABCD[X]]) && ((zz[aXABCD[C]] - zz[aXABCD[D]]) >= (zz[aXABCD[2]] - zz[aXABCD[B]]) * ExtCD))
        {
         vBullBear = vBull;
        }
      else if ((zz[aXABCD[X]] > zz[aXABCD[D]]) && (zz[aXABCD[D]] > zz[aXABCD[B]]) && (zz[aXABCD[B]] > zz[aXABCD[C]]) && (zz[aXABCD[C]] > zz[aXABCD[A]]) && ((zz[aXABCD[D]] - zz[aXABCD[C]]) >= (zz[aXABCD[B]] - zz[aXABCD[A]]) * ExtCD))
        {
         vBullBear = vBear;
        }
      else if ((zz[aXABCD[D]] > zz[aXABCD[X]]) && (zz[aXABCD[X]] > zz[aXABCD[B]]) && (zz[aXABCD[B]] > zz[aXABCD[C]]) && (zz[aXABCD[C]] > zz[aXABCD[A]]) && ((zz[aXABCD[D]] - zz[aXABCD[C]]) >= (zz[aXABCD[B]] - zz[aXABCD[A]]) * ExtCD))
        {
         vBullBear = vBear;
        }

      if (vBullBear!="")
        {
         if (vBullBear == vBull)
           {
            retXB = (zz[aXABCD[A]] - zz[aXABCD[B]]) / (zz[aXABCD[A]] - zz[aXABCD[X]] + vDelta0);
            retXD = (zz[aXABCD[A]] - zz[aXABCD[D]]) / (zz[aXABCD[A]] - zz[aXABCD[X]] + vDelta0);
            retBD = (zz[aXABCD[C]] - zz[aXABCD[D]]) / (zz[aXABCD[C]] - zz[aXABCD[B]] + vDelta0);
            retAC = (zz[aXABCD[C]] - zz[aXABCD[B]]) / (zz[aXABCD[A]] - zz[aXABCD[B]] + vDelta0);
            if (RangeForPointD>0 && FlagForD)
              {
               XA=zz[aXABCD[A]] - zz[aXABCD[X]];
               BC=zz[aXABCD[C]] - zz[aXABCD[B]];
              }
           }
         else if (vBullBear == vBear)
           {
            retXB = (zz[aXABCD[B]] - zz[aXABCD[A]]) / (zz[aXABCD[X]] - zz[aXABCD[A]] + vDelta0);
            retXD = (zz[aXABCD[D]] - zz[aXABCD[A]]) / (zz[aXABCD[X]] - zz[aXABCD[A]] + vDelta0);
            retBD = (zz[aXABCD[D]] - zz[aXABCD[C]]) / (zz[aXABCD[B]] - zz[aXABCD[C]] + vDelta0);
            retAC = (zz[aXABCD[B]] - zz[aXABCD[C]]) / (zz[aXABCD[B]] - zz[aXABCD[A]] + vDelta0);
            if (RangeForPointD>0 && FlagForD)
              {
               XA=zz[aXABCD[X]] - zz[aXABCD[A]];
               BC=zz[aXABCD[B]] - zz[aXABCD[C]];
              }
           }

         if ((retAC >= vl0382) && (retAC <= vh0886) && (retXD >= vl0618) && (retXD <= vh0786) && (retBD >= vl1128) && (retBD <= vh2236) && (retXB >= vl0382) && (retXB <= vh0618))
           {
            vNamePattern=vGartley; // Gartley
            if (RangeForPointD>0 && FlagForD)
              {
               if (vBullBear == vBull)
                 {
                  LevelForDmin = MathMax(zz[aXABCD[A]]-XA*vh0786,zz[aXABCD[C]]-BC*vh2236);
                  LevelForDmax = MathMin(zz[aXABCD[A]]-XA*vl0618,zz[aXABCD[C]]-BC*vl1128);
                 }
               else if (vBullBear == vBear)
                 {
                  LevelForDmin = MathMax(zz[aXABCD[A]]+XA*vl0618,zz[aXABCD[C]]+BC*vl1128);
                  LevelForDmax = MathMin(zz[aXABCD[A]]+XA*vh0786,zz[aXABCD[C]]+BC*vh2236);
                 }
              }
           }
         else if ((retAC >= vl0382) && (retAC <= vh0886) && (retXD >= vl1272) && (retXD <= vh1618) && (retBD >= vl1272) && (retBD <= vh2618) && (retXB >= vl0618) && (retXB <= vh0886))
           {
            vNamePattern=vButterfly; // Butterfly
            if (RangeForPointD>0 && FlagForD)
              {
               if (vBullBear == vBull)
                 {
                  LevelForDmin = MathMax(zz[aXABCD[A]]-XA*vh1618,zz[aXABCD[C]]-BC*vh2618);
                  LevelForDmax = MathMin(zz[aXABCD[A]]-XA*vl1272,zz[aXABCD[C]]-BC*vl1272);
                 }
               else if (vBullBear == vBear)
                 {
                  LevelForDmin = MathMax(zz[aXABCD[A]]+XA*vl1272,zz[aXABCD[C]]+BC*vl1272);
                  LevelForDmax = MathMin(zz[aXABCD[A]]+XA*vh1618,zz[aXABCD[C]]+BC*vh2618);
                 }
              }
           }
         else if ((retAC >= vl0382) && (retAC <= vh0886) && (retXD >= vl1618) && (retXD <= vh1618) && (retBD >= vl2236) && (retBD <= vh3618) && (retXB >= vl0382) && (retXB <= vh0618))
           {
            vNamePattern=vCrab; // Crab
            if (RangeForPointD>0 && FlagForD)
              {
               if (vBullBear == vBull)
                 {
                  LevelForDmin = MathMax(zz[aXABCD[A]]-XA*vh1618,zz[aXABCD[C]]-BC*vh3618);
                  LevelForDmax = MathMin(zz[aXABCD[A]]-XA*vl1618,zz[aXABCD[C]]-BC*vl2236);
                 }
               else if (vBullBear == vBear)
                 {
                  LevelForDmin = MathMax(zz[aXABCD[A]]+XA*vl1618,zz[aXABCD[C]]+BC*vl2236);
                  LevelForDmax = MathMin(zz[aXABCD[A]]+XA*vh1618,zz[aXABCD[C]]+BC*vh3618);
                 }
              }
           }
         else  if ((retAC >= vl0382) && (retAC <= vh0886) && (retXD >= vl0886) && (retXD <= vh0886) && (retBD >= vl1272) && (retBD <= vh2618) && (retXB >= vl0382) && (retXB <= vh0618))
           {
            vNamePattern=vBat; // Bat
            if (RangeForPointD>0 && FlagForD)
              {
               if (vBullBear == vBull)
                 {
                  LevelForDmin = MathMax(zz[aXABCD[A]]-XA*vh0886,zz[aXABCD[C]]-BC*vh2618);
                  LevelForDmax = MathMin(zz[aXABCD[A]]-XA*vl0886,zz[aXABCD[C]]-BC*vl1272);
                 }
               else if (vBullBear == vBear)
                 {
                  LevelForDmin = MathMax(zz[aXABCD[A]]+XA*vl0886,zz[aXABCD[C]]+BC*vl1272);
                  LevelForDmax = MathMin(zz[aXABCD[A]]+XA*vh0886,zz[aXABCD[C]]+BC*vh2618);
                 }
              }
           }
        }

//      if ((vNamePattern != "") && ((aXABCD[D] < aNumBarPeak[j-1]) && VarDisplay==0) )
//            if ((vNamePattern != "") && ((aXABCD[D] < maxBarToD) && VarDisplay==0) )
      if ((vNamePattern != "") && (aXABCD[D] < maxBarToD+2))
        {
         nameObj1="_"+ExtComplekt+"Triangle1_" + _Depth + "_" + aXABCD[D] + "";
         ObjectDelete(nameObj1);
         nameObj2="_"+ExtComplekt+"Triangle2_" + _Depth + "_" + aXABCD[D] + "";
         ObjectDelete(nameObj2);

         vPatOnOff = 1;

         if (vBullBear == vBull)
           {
            ObjectCreate(nameObj1,OBJ_TRIANGLE,0,Time[aXABCD[X]],zz[aXABCD[X]],Time[aXABCD[B]],zz[aXABCD[B]],Time[aXABCD[A]],zz[aXABCD[A]]);
            ObjectSet(nameObj1,OBJPROP_COLOR,ExtColorPatterns);
            ObjectCreate(nameObj2,OBJ_TRIANGLE,0,Time[aXABCD[B]],zz[aXABCD[B]],Time[aXABCD[D]],zz[aXABCD[D]],Time[aXABCD[C]],zz[aXABCD[C]]);
            ObjectSet(nameObj2,OBJPROP_COLOR,ExtColorPatterns);
           }
         else
           {
            ObjectCreate(nameObj1,OBJ_TRIANGLE,0,Time[aXABCD[X]],zz[aXABCD[X]],Time[aXABCD[B]],zz[aXABCD[B]],Time[aXABCD[A]],zz[aXABCD[A]]);
            ObjectSet(nameObj1,OBJPROP_COLOR,ExtColorPatterns);
            ObjectCreate(nameObj2,OBJ_TRIANGLE,0,Time[aXABCD[B]],zz[aXABCD[B]],Time[aXABCD[D]],zz[aXABCD[D]],Time[aXABCD[C]],zz[aXABCD[C]]);
            ObjectSet(nameObj2,OBJPROP_COLOR,ExtColorPatterns);
           }

         if (RangeForPointD>0) // ����� �������������� ��� ���� ����� D
           {
            if (FlagForD)
              {
//               FlagForD=false;
               for (j=aXABCD[D];j<aXABCD[C]-1;j++)
                 {
                  if (vBullBear == vBull)
                    {
                     if (LevelForDmax>=Low[j]) TimeForDmax  = Time[j];
                    }
                  else if (vBullBear == vBear)
                    {
                     if (LevelForDmin<=High[j]) TimeForDmin  = Time[j];
                    }
                 }

               if (vBullBear == vBull)
                 {
                  TimeForDmin  = TimeForDmax+((LevelForDmax-LevelForDmin)/((zz[aXABCD[C]]-zz[aXABCD[D]])/(aXABCD[C]-aXABCD[D]+1)))*Period()*60;
                 }
               else if (vBullBear == vBear)
                 {
                  TimeForDmax  = TimeForDmin+((LevelForDmax-LevelForDmin)/((zz[aXABCD[D]]-zz[aXABCD[C]])/(aXABCD[C]-aXABCD[D]+1)))*Period()*60;
                 }

               nameObj="_"+ExtComplekt+"PointD";
//               ObjectDelete(nameObj);

               ObjectCreate(nameObj,OBJ_RECTANGLE,0,TimeForDmin,LevelForDmin,TimeForDmax,LevelForDmax);
               ObjectSet(nameObj, OBJPROP_BACK, false);
               ObjectSet(nameObj, OBJPROP_COLOR, ExtColorRangeForPointD); 
              }

           }
         return(0);
        }
      else 
        {
         vBullBear = "";
         vNamePattern = "";
/*
         if (RangeForPointD>0)
           {
            FlagForD=true;
            ObjectDelete("_"+ExtComplekt+"PointD");
           }
*/
        }
      k++;
     }
  }
//--------------------------------------------------------
// ����� ��������� Gartley. �����.
//--------------------------------------------------------


//----------------------------------------------------
//  ZigZag ������ ������� ����������. ������.
//----------------------------------------------------
void ang_AZZ_()
 {
   int i,n;

//   cbi=Bars-IndicatorCounted()-1;
//---------------------------------
   for (i=cbi; i>=0; i--) 
     {
//-------------------------------------------------
      // ���������� �������� ����������� ������ fs � ������� ���� si �� ���������� ����
      if (ti!=Time[i]) {fsp=fs; sip=si;} ti=Time[i];
      // ��������� �������� �������� ������� �� �������� ����������
      if (minSize==0 && minPercent!=0) di=minPercent*Close[i]/2/100;
//-------------------------------------------------
      // ������������� ������� ����
      if (High[i]>=si+di && Low[i]<si-di) // ������� ��� �� ��������� � �������� ������� di
        {
         if (High[i]-si>=si-Low[i]) si=High[i]-di;  // ���������� ��� �� ������� ���� ������ ���������� ����
         if (High[i]-si<si-Low[i]) si=Low[i]+di;  // ��������������, ������
        } 
      else  // �� ������� ���
        {
         if (High[i]>=si+di) si=High[i]-di;   // 
         if (Low[i]<=si-di) si=Low[i]+di;   // 
        }

      // ���������� ���������� �������� ������� ����
      if (i>Bars-2) {si=(High[i]+Low[i])/2;}

      // ��������� ������ ��� ������� �������������
      if (chHL && chHL_PeakDet_or_vts) {ha[i]=si+di; la[i]=si-di;} 

      // ���������� ����������� ������ ��� ���������� ����
      if (si>sip) fs=1; // ����� ����������
      if (si<sip) fs=2; // ����� ����������

//-------------------------------------------------

      if (fs==1 && fsp==2) // ����� �������� � ����������� �� ����������
        {
         hm=High[i];

         zz[bi]=Low[bi];
         zzL[bi]=Low[bi];
         if (i>0) {if (PeakDet && chHL_PeakDet_or_vts) for (n=bip; n>=bi; n--) {lam[n]=Low[bip];}}
         aip=ai; 
         taip=Time[ai];
         ai=i;
         tai=Time[i];
         fsp=fs;
        }

      if (fs==2 && fsp==1) // ����� �������� � ����������� �� ����������
        {
         lm=Low[i]; 

         zz[ai]=High[ai];
         zzH[ai]=High[ai];
         if (i>0) {if (PeakDet && chHL_PeakDet_or_vts) for (n=aip; n>=ai; n--) {ham[n]=High[aip];}}
         bip=bi; 
         tbip=Time[bi];
         bi=i;
         tbi=Time[i];
         fsp=fs;
        }

      // ����������� t�����. ������������ ������.
      if (fs==1 && High[i]>hm) 
        {hm=High[i]; ai=i; tai=Time[i];}
      if (fs==2 && Low[i]<lm) 
        {lm=Low[i]; bi=i; tbi=Time[i];}

//===================================================================================================
      // ������� ���. ������ ������� ���� ZigZag-a

      if (i==0) 
        {
         ai0=iBarShift(Symbol(),Period(),tai); 
         bi0=iBarShift(Symbol(),Period(),tbi);
         aip0=iBarShift(Symbol(),Period(),taip); 
         bip0=iBarShift(Symbol(),Period(),tbip);

         if (fs==1) {for (n=bi0-1; n>ai0; n--) {zzH[n]=0; zz[n]=0;} zz[ai0]=High[ai0]; zzH[ai0]=High[ai0]; zzL[ai0]=0;}         
         if (fs==2) {for (n=ai0-1; n>bi0; n--) {zzL[n]=0; zz[n]=0;} zz[bi0]=Low[bi0]; zzL[bi0]=Low[bi0]; zzH[bi0]=0;}

         if (PeakDet)
           {
            if (fs==1) 
              {
               for (n=aip0; n>=0; n--) {ham[n]=High[aip0];}
               for (n=bi0; n>=0; n--) {lam[n]=Low[bi0];}
              }
            if (fs==2)
              {
               for (n=bip0; n>=0; n--) {lam[n]=Low[bip0];} 
               for (n=ai0; n>=0; n--) {ham[n]=High[ai0];} 
              } 
           }

        }
//====================================================================================================
     }
//--------------------------------------------
 }

//--------------------------------------------------------
// ZigZag ������. �����. 
//--------------------------------------------------------


//----------------------------------------------------
// ��������� �������� ����������� � Ensign. ������.
//----------------------------------------------------
void Ensign_ZZ()
 {
   int i,n;

//   cbi=Bars-IndicatorCounted()-1;
//---------------------------------
   for (i=cbi; i>=0; i--) 
     {
//-------------------------------------------------
      // ������������� ��������� �������� �������� � ��������� ����
      if (lLast==0) {lLast=Low[i];hLast=High[i]; if (ExtIndicator==3) di=hLast-lLast;}

      // ���������� ����������� ������ �� ������ ����� ����� ������.
      // ��� �� ����� ������ ������� ���� �� ����� �����.
      if (fs==0)
        {
         if (lLast<Low[i] && hLast<High[i]) {fs=1; hLast=High[i]; si=High[i]; ai=i; tai=Time[i]; if (ExtIndicator==3) di=High[i]-Low[i];}  // ����� ����������
         if (lLast>Low[i] && hLast>High[i]) {fs=2; lLast=Low[i]; si=Low[i]; bi=i; tbi=Time[i]; if (ExtIndicator==3) di=High[i]-Low[i];}  // ����� ����������
        }

      if (ti!=Time[i])
        {
         // ���������� �������� ����������� ������ fs �� ���������� ����
         ti=Time[i];

         ai0=iBarShift(Symbol(),Period(),tai); 
         bi0=iBarShift(Symbol(),Period(),tbi);

         fcount0=false;
         if ((fh || fl) && countBar>0) {countBar--; if (i==0 && countBar==0) fcount0=true;}
         // ���������. ����������� ����������� ����������� ������.
         if (fs==1)
           {
            if (hLast>High[i] && !fh) fh=true;

            if (i==0)
              {

               if (Close[i+1]<lLast && fh) {fs=2; countBar=minBars; fh=false;}
               if (countBar==0 && si-di>Low[i+1] && High[i+1]<hLast && ai0>i+1 && fh && !fcount0) {fs=2; countBar=minBars; fh=false;}

               if (fs==2) // ����� �������� � ����������� �� ���������� �� ���������� ����
                 {
                  zz[ai0]=High[ai0];
                  zzH[ai0]=High[ai0];
                  if (PeakDet && chHL_PeakDet_or_vts) for (n=aip; n>=ai; n--) {ham[n]=High[aip];}
                  lLast=Low[i+1];
                  if (ExtIndicator==3) di=High[i+1]-Low[i+1];
                  si=Low[i+1];
                  bip=bi0; 
                  tbip=Time[bi0];
                  bi=i+1;
                  tbi=Time[i+1];
                  if (chHL && chHL_PeakDet_or_vts) {ha[i+1]=si+di; la[i+1]=si;}
                }

              }
            else
              {
               if (Close[i]<lLast && fh) {fs=2; countBar=minBars; fh=false;}
               if (countBar==0 && si-di>Low[i] && High[i]<hLast && fh) {fs=2; countBar=minBars; fh=false;}

               if (fs==2) // ����� �������� � ����������� �� ����������
                 {
                  zz[ai]=High[ai];
                  zzH[ai]=High[ai];
                  if (PeakDet && chHL_PeakDet_or_vts) for (n=aip; n>=ai; n--) {ham[n]=High[aip];}
                  lLast=Low[i];
                  if (ExtIndicator==3) di=High[i]-Low[i];
                  si=Low[i];
                  bip=bi; 
                  tbip=Time[bi];
                  bi=i;
                  tbi=Time[i];
                  if (chHL && chHL_PeakDet_or_vts) {ha[i]=si+di; la[i]=si;}
                 }
              }

           }
         else // fs==2
           {
            if (lLast<Low[i] && !fl) fl=true;

            if (i==0)
              {

               if (Close[i+1]>hLast && fl) {fs=1; countBar=minBars; fl=false;}
               if (countBar==0 && si+di<High[i+1] && Low[i+1]>lLast && bi0>i+1 && fl && !fcount0) {fs=1; countBar=minBars; fl=false;}

               if (fs==1) // ����� �������� � ����������� �� ���������� �� ���������� ����
                 {
                  zz[bi0]=Low[bi0];
                  zzL[bi0]=Low[bi0];
                  if (PeakDet && chHL_PeakDet_or_vts) for (n=bip; n>=bi; n--) {lam[n]=Low[bip];}
                  hLast=High[i+1];
                  if (ExtIndicator==3) di=High[i+1]-Low[i+1];
                  si=High[i+1];
                  aip=ai0; 
                  taip=Time[ai0];
                  ai=i+1;
                  tai=Time[i+1];
                  if (chHL && chHL_PeakDet_or_vts) {ha[i+1]=si; la[i+1]=si-di;}
                 }

              }
            else
              {
               if (Close[i]>hLast && fl) {fs=1; countBar=minBars; fl=false;}
               if (countBar==0 && si+di<High[i] && Low[i]>lLast && fl) {fs=1; countBar=minBars; fl=false;}

               if (fs==1) // ����� �������� � ����������� �� ����������
                 {
                  zz[bi]=Low[bi];
                  zzL[bi]=Low[bi];
                  if (PeakDet && chHL_PeakDet_or_vts) for (n=bip; n>=bi; n--) {lam[n]=Low[bip];}
                  hLast=High[i];
                  if (ExtIndicator==3) di=High[i]-Low[i];
                  si=High[i];
                  aip=ai; 
                  taip=Time[ai];
                  ai=i;
                  tai=Time[i];
                  if (chHL && chHL_PeakDet_or_vts) {ha[i]=si; la[i]=si-di;}
                 }
              }
           }
        } 

      // ����������� ������
      if (fs==1 && High[i]>si) {ai=i; tai=Time[i]; hLast=High[i]; si=High[i]; countBar=minBars; fh=false; if (ExtIndicator==3) di=High[i]-Low[i];}
      if (fs==2 && Low[i]<si) {bi=i; tbi=Time[i]; lLast=Low[i]; si=Low[i]; countBar=minBars; fl=false; if (ExtIndicator==3) di=High[i]-Low[i];}

      // ��������� ������ ��� ������� �������������
      if (chHL && chHL_PeakDet_or_vts)
        {
         if (fs==1) {ha[i]=si; la[i]=si-di;}
         if (fs==2) {ha[i]=si+di; la[i]=si;}
        } 

//===================================================================================================
      // ������� ���. ������ ������� ���� ZigZag-a

      if (i==0) 
        {
         ai0=iBarShift(Symbol(),Period(),tai); 
         bi0=iBarShift(Symbol(),Period(),tbi);
         aip0=iBarShift(Symbol(),Period(),taip); 
         bip0=iBarShift(Symbol(),Period(),tbip);

         if (fs==1) {for (n=bi0-1; n>=0; n--) {zzH[n]=0; zz[n]=0;} zz[ai0]=High[ai0]; zzH[ai0]=High[ai0]; zzL[ai0]=0;}         
         if (fs==2) {for (n=ai0-1; n>=0; n--) {zzL[n]=0; zz[n]=0;} zz[bi0]=Low[bi0]; zzL[bi0]=Low[bi0]; zzH[bi0]=0;}

         if (PeakDet && chHL_PeakDet_or_vts)
           {
            if (fs==1) {for (n=aip0; n>=0; n--) {ham[n]=High[aip0];} for (n=bi0; n>=0; n--) {lam[n]=Low[bi0];} }
            if (fs==2) {for (n=bip0; n>=0; n--) {lam[n]=Low[bip0];} for (n=ai0; n>=0; n--) {ham[n]=High[ai0];} } 
           }
        }

//====================================================================================================
     }
//--------------------------------------------
 }
//--------------------------------------------------------
// ��������� �������� ����������� � Ensign. �����. 
//--------------------------------------------------------


//----------------------------------------------------
//  ZigZag tauber. ������.
//----------------------------------------------------

void ZigZag_tauber()
  {
//  ZigZag �� ��. ������.
   int    shift, back,lasthighpos,lastlowpos;
   double val,res;
   double curlow,curhigh,lasthigh,lastlow;
   GetHigh(0,Bars,0.0,0);

   // final cutting 
   lasthigh=-1; lasthighpos=-1;
   lastlow=-1;  lastlowpos=-1;

   for(shift=Bars; shift>=0; shift--)
     {
      curlow=zzL[shift];
      curhigh=zzH[shift];
      if((curlow==0)&&(curhigh==0)) continue;
      //---
      if(curhigh!=0)
        {
        if(lasthigh>0) 
           {
            if(lasthigh<curhigh) zzH[lasthighpos]=0;
            else zzH[shift]=0;
           }
        //---
         if(lasthigh<curhigh || lasthigh<0)
           {
            lasthigh=curhigh;
            lasthighpos=shift;
           }
         lastlow=-1;
        }
      //----
      if(curlow!=0)
        {
         if(lastlow>0)
           {
            if(lastlow>curlow) zzL[lastlowpos]=0;
            else zzL[shift]=0;
          }
         //---
         if((curlow<lastlow)||(lastlow<0))
           {
            lastlow=curlow;
            lastlowpos=shift;
           } 
         lasthigh=-1;
        }
     }
  

   for(shift=Bars-1; shift>=0; shift--)
     {
      zz[shift]=zzL[shift];
      res=zzH[shift];
      if(res!=0.0) zz[shift]=res;
     }

  }

void GetHigh(int start, int end, double price, int step)
  {
   int count=end-start;
   if (count<=0) return;
   int i=iHighest(NULL,0,MODE_HIGH,count+1,start);
   double val=High[i];
   if ((val-price)>(minSize*Point))
     { 
      zzH[i]=val;
      if (i==start) {GetLow(start+step,end-step,val,1-step); if (zzL[start-1]>0) zzL[start]=0; return;}     
      if (i==end) {GetLow(start+step,end-step,val,1-step); if (zzL[end+1]>0) zzL[end]=0; return;} 
      GetLow(start,i-1,val,0);
      GetLow(i+1,end,val,0);
     }
  }

void GetLow(int start, int end, double price, int step)
  {
   int count=end-start;
   if (count<=0) return;
   int i=iLowest(NULL,0,MODE_LOW,count+1,start);
   double val=Low[i];
   if ((price-val)>(minSize*Point))
     {
      zzL[i]=val; 
      if (i==start) {GetHigh(start+step,end-step,val,1-step); if (zzH[start-1]>0) zzH[start]=0; return;}     
      if (i==end) {GetHigh(start+step,end-step,val,1-step); if (zzH[end+1]>0) zzH[end]=0; return;}   
      GetHigh(start,i-1,val,0);
      GetHigh(i+1,end,val,0);
     }
  }
//--------------------------------------------------------
// ZigZag tauber. �����. 
//--------------------------------------------------------

//----------------------------------------------------
// ������ �����. ������.
//----------------------------------------------------
void GannSwing()
 {
   int i,n,fs_tend=0;
// lLast, hLast - ������� � �������� ��������� ����
// lLast_m, hLast_m - ������� � �������� "�������������" �����

//   cbi=Bars-IndicatorCounted()-1;
//---------------------------------
   for (i=cbi; i>=0; i--) 
     {
//-------------------------------------------------
      // ������������� ��������� �������� �������� � ��������� ����
      if (lLast==0) {lLast=Low[i]; hLast=High[i]; ai=i; bi=i;}
      if (ti!=Time[i])
        {
         ti=Time[i];
         if (lLast_m==0 && hLast_m==0)
           {
            if (lLast>Low[i] && hLast<High[i]) // ������� ���
              {
               lLast=Low[i];hLast=High[i];lLast_m=Low[i];hLast_m=High[i];countBarExt++;
               if (fs==1) {countBarl=countBarExt; ai=i; tai=Time[i];}
               else if (fs==2) {countBarh=countBarExt; bi=i; tbi=Time[i];}
               else {countBarl++;countBarh++;}
              }
            else if (lLast<=Low[i] && hLast<High[i]) // ��������� �� ������� ���� ����������
              {
               lLast_m=0;hLast_m=High[i];countBarl=0;countBarExt=0;
               if (fs!=1) countBarh++;
               else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; ai=i; tai=Time[i];}
              }
            else if (lLast>Low[i] && hLast>=High[i]) // ��������� �� ������� ���� ����������
              {
               lLast_m=Low[i];hLast_m=0;countBarh=0;countBarExt=0;
               if (fs!=2) countBarl++;
               else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; bi=i; tbi=Time[i];}
              }
           }
         else  if (lLast_m>0 && hLast_m>0) // ������� ��� (����������)
           {
            if (lLast_m>Low[i] && hLast_m<High[i]) // ������� ���
              {
               lLast=Low[i];hLast=High[i];lLast_m=Low[i];hLast_m=High[i];countBarExt++;
               if (fs==1) {countBarl=countBarExt; ai=i; tai=Time[i];}
               else if (fs==2) {countBarh=countBarExt; bi=i; tbi=Time[i];}
               else {countBarl++;countBarh++;}
              }
            else if (lLast_m<=Low[i] && hLast_m<High[i]) // ��������� �� ������� ���� ����������
              {
               lLast_m=0;hLast_m=High[i];countBarl=0;countBarExt=0;
               if (fs!=1) countBarh++;
               else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; ai=i; tai=Time[i];}
              }
            else if (lLast_m>Low[i] && hLast_m>=High[i]) // ��������� �� ������� ���� ����������
              {
               lLast_m=Low[i];hLast_m=0;countBarh=0;countBarExt=0;
               if (fs!=2) countBarl++;
               else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; bi=i; tbi=Time[i];}
              }
           }
         else  if (lLast_m>0)
           {
            if (lLast_m>Low[i] && hLast<High[i]) // ������� ���
              {
               lLast=Low[i];hLast=High[i];lLast_m=Low[i];hLast_m=High[i];countBarExt++;
               if (fs==1) {countBarl=countBarExt; ai=i; tai=Time[i];}
               else if (fs==2) {countBarh=countBarExt; bi=i; tbi=Time[i];}
               else {countBarl++;countBarh++;}
              }
            else if (lLast_m<=Low[i] && hLast<High[i]) // ��������� �� ������� ���� ����������
              {
               lLast_m=0;hLast_m=High[i];countBarl=0;countBarExt=0;
               if (fs!=1) countBarh++;
               else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; ai=i; tai=Time[i];}
              }
            else if (lLast_m>Low[i] && hLast>=High[i]) // ��������� �� ������� ���� ����������
              {
               lLast_m=Low[i];hLast_m=0;countBarh=0;countBarExt=0;
               if (fs!=2) countBarl++;
               else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; bi=i; tbi=Time[i];}
              }
           }
         else  if (hLast_m>0)
           {
            if (lLast>Low[i] && hLast_m<High[i]) // ������� ���
              {
               lLast=Low[i];hLast=High[i];lLast_m=Low[i];hLast_m=High[i];countBarExt++;
               if (fs==1) {countBarl=countBarExt; ai=i; tai=Time[i];}
               else if (fs==2) {countBarh=countBarExt; bi=i; tbi=Time[i];}
               else {countBarl++;countBarh++;}
              }
            else if (lLast<=Low[i] && hLast_m<High[i]) // ��������� �� ������� ���� ����������
              {
               lLast_m=0;hLast_m=High[i];countBarl=0;countBarExt=0;
               if (fs!=1) countBarh++;
               else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; ai=i; tai=Time[i];}
              }
            else if (lLast>Low[i] && hLast_m>=High[i]) // ��������� �� ������� ���� ����������
              {
               lLast_m=Low[i];hLast_m=0;countBarh=0;countBarExt=0;
               if (fs!=2) countBarl++;
               else {lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0; bi=i; tbi=Time[i];}
              }
           }

         // ���������� ����������� ������. 
         if (fs==0)
           {
            if (lLast<lLast_m && hLast>hLast_m) // ���������� ���
              {
               lLast=Low[i]; hLast=High[i]; ai=i; bi=i; countBarl=0;countBarh=0;countBarExt=0;
              }
              
            if (countBarh>countBarl && countBarh>countBarExt && countBarh>minBars)
              {
               lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0;
               fs=1;countBarh=0;countBarl=0;countBarExt=0;
               zz[bi]=Low[bi];
               zzL[bi]=Low[bi];
               zzH[bi]=0;
               ai=i;
               tai=Time[i];
              }
            else if (countBarl>countBarh && countBarl>countBarExt && countBarl>minBars)
              {
               lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0;
               fs=2;countBarl=0;countBarh=0;countBarExt=0;
               zz[ai]=High[ai];
               zzH[ai]=High[ai];
               zzL[ai]=0;
               bi=i;
               tbi=Time[i];
              }
           }
         else
           {
            if (lLast_m==0 && hLast_m==0)
              {
               countBarl=0;countBarh=0;countBarExt=0;
              }

            // ��������� ����������
            if (fs==1)
              {
                  if (countBarl>countBarh && countBarl>countBarExt && countBarl>minBars) // ���������� ����� ����� ���������.
                    {
                     // ���������� �������� ����������� ������ fs �� ���������� ����
                     ai0=iBarShift(Symbol(),Period(),tai); 
                     bi0=iBarShift(Symbol(),Period(),tbi);
                     fs=2;
                     countBarl=0;

                     zz[ai]=High[ai];
                     zzH[ai]=High[ai];
                     zzL[ai]=0;
                     bi=i;
                     tbi=Time[i];

                     lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0;

                     for (n=0;countBarExt<minBars;n++) 
                       {
                        if (lLast<Low[i+n+1] && hLast>High[i+n+1]) {countBarExt++; countBarh++; lLast=Low[i+n+1]; hLast=High[i+n+1]; hLast_m=High[i];}
                        else break;
                       }

                     lLast=Low[i]; hLast=High[i];

                    }
              }

            // ��������� ����������
            if (fs==2)
              {
                  if (countBarh>countBarl && countBarh>countBarExt && countBarh>minBars) // ���������� ����� ����� ���������.
                    {
                     // ���������� �������� ����������� ������ fs �� ���������� ����
                     ai0=iBarShift(Symbol(),Period(),tai); 
                     bi0=iBarShift(Symbol(),Period(),tbi);
                     fs=1;
                     countBarh=0;

                     zz[bi]=Low[bi];
                     zzL[bi]=Low[bi];
                     zzH[bi]=0;
                     ai=i;
                     tai=Time[i];

                     lLast=Low[i]; hLast=High[i]; lLast_m=0; hLast_m=0;

                     for (n=0;countBarExt<minBars;n++) 
                       {
                        if (lLast<Low[i+n+1] && hLast>High[i+n+1]) {countBarExt++; countBarl++; lLast=Low[i+n+1]; hLast=High[i+n+1]; lLast_m=Low[i];}
                        else break;
                       }

                     lLast=Low[i]; hLast=High[i];

                    }
              }
           } 
        } 
       if (i==0)
         {
          if (hLast<High[i] && fs==1) // ��������� �� ������� ���� ����������
            {
             ai=i; tai=Time[i]; zz[ai]=High[ai]; zzH[ai]=High[ai]; zzL[ai]=0;
            }
          else if (lLast>Low[i] && fs==2) // ��������� �� ������� ���� ����������
            {
             bi=i; tbi=Time[i]; zz[bi]=Low[bi]; zzL[bi]=Low[bi]; zzH[bi]=0;
            }
//===================================================================================================
      // ������� ���. ������ ������� ���� ZigZag-a

          ai0=iBarShift(Symbol(),Period(),tai); 
          bi0=iBarShift(Symbol(),Period(),tbi);

          if (bi0>1) if (fs==1) {for (n=bi0-1; n>=0; n--) {zzH[n]=0.0; zz[n]=0.0;} zz[ai0]=High[ai0]; zzH[ai0]=High[ai0]; zzL[ai0]=0.0;}         
          if (ai0>1) if (fs==2) {for (n=ai0-1; n>=0; n--) {zzL[n]=0.0; zz[n]=0.0;} zz[bi0]=Low[bi0]; zzL[bi0]=Low[bi0]; zzH[bi0]=0.0;}

          if (ti<Time[1]) i=2;

         }
//====================================================================================================

     }
//--------------------------------------------
 }
//--------------------------------------------------------
// ������ �����. �����. 
//--------------------------------------------------------


//----------------------------------------------------
// nen-ZigZag. ������.
//----------------------------------------------------
void nenZigZag()
 {
  if (cbi>0)
    {
     datetime nen_time=iTime(NULL,GrossPeriod,0);
     int i=0, j=0; // j - ����� ���� � ������������ ���������� (����������� ���������) � ������� nen-ZigZag
     double nen_dt=0, last_j=0, last_nen=0; //last_j - �������� ������������� ��������� (������������ ��������) � ������� nen_ZigZag
     int limit, big_limit, bigshift=0;

     if (init_zz)
       {
        limit=Bars-1;
        big_limit=iBars(NULL,GrossPeriod)-1;
       }
     else
       {
        limit=iBarShift(NULL,0,afr[2]);
        big_limit=iBarShift(NULL,GrossPeriod,afr[2]);
       }

     while (bigshift<big_limit && i<limit) // ��������� ���������� ������ nen-ZigZag ("�������")
       {
        if (Time[i]>=nen_time)
          {
           if (ExtIndicator==6) nen_ZigZag[i]=iCustom(NULL,GrossPeriod,"ZigZag_new_nen3",minBars,ExtDeviation,ExtBackstep,0,bigshift);
           else  if (ExtIndicator==7) nen_ZigZag[i]=iCustom(NULL,GrossPeriod,"DT_ZZ",minBars,0,bigshift);
           else  if (ExtIndicator==8) nen_ZigZag[i]=iCustom(NULL,GrossPeriod,"CZigZag",minBars,ExtDeviation,0,bigshift);
           else  if (ExtIndicator==10) nen_ZigZag[i]=iCustom(NULL,GrossPeriod,"Swing_ZZ",minBars,0,bigshift);
           i++;
          }
        else {bigshift++;nen_time=iTime(NULL,GrossPeriod,bigshift);}
       }

     if (init_zz) // ��������� �������
       {
        double i1=0, i2=0;
        init_zz=false;

        for (i=limit;i>0;i--) // ����������� ����������� ������� ����
          {
           if (nen_ZigZag[i]>0)
             {
              if (i1==0) i1=nen_ZigZag[i];
              else if (i1>0 && i1!=nen_ZigZag[i]) i2=nen_ZigZag[i];
              if (i2>0) 
                {
                 if (i1>i2) hi_nen=true;
                 else hi_nen=false;
                 break;
                }
             }
          }
       }
     else // ����� ��������� �������
       {
        if (afrl[2]>0) hi_nen=false; else hi_nen=true;
       }

     for (i=limit;i>=0;i--)
       {
//        if (i<limit) 
        {zz[i]=0; zzH[i]=0; zzL[i]=0;}

        if (nen_ZigZag[i]>0)
          {
           if (nen_dt>0 && nen_dt!=nen_ZigZag[i])
             {
              if (hi_nen) {hi_nen=false;zzH[j]=last_nen;}
              else {hi_nen=true;zzL[j]=last_nen;}
              last_j=0;nen_dt=0;zz[j]=last_nen;
             }

           if (hi_nen)
             {
              nen_dt=nen_ZigZag[i];
              if (last_j<High[i]) {j=i;last_j=High[i];last_nen=nen_ZigZag[i];}
             }
           else
             {
              nen_dt=nen_ZigZag[i];
              if (last_j==0) {j=i;last_j=Low[i];last_nen=nen_ZigZag[i];}
              if (last_j>Low[i]) {j=i;last_j=Low[i];last_nen=nen_ZigZag[i];}
             }

           if (nen_dt>0 && i==0)  // ����������� �������� �� ������� ���� GrossPeriod
             {
              zz[j]=last_nen;
              if (hi_nen) zzH[j]=last_nen; else zzL[j]=last_nen;
             }
          }
        else
          {
           if (last_j>0)
             {
              if (hi_nen) {hi_nen=false;zzH[j]=last_nen;}
              else {hi_nen=true;zzL[j]=last_nen;}
              last_j=0;nen_dt=0;zz[j]=last_nen;
             }
          }
       }
     }
 }
//--------------------------------------------------------
// nen-ZigZag. �����. 
//--------------------------------------------------------

/*------------------------------------------------------------------+
|  ZigZag_Talex, ���� ����� �������� �� �������. ���������� �����   |
|  �������� ������� ���������� ExtPoint.                            |
+------------------------------------------------------------------*/
void ZZTalex(int n)
{
/*����������*/
   int    i,j,k,zzbarlow,zzbarhigh,curbar,curbar1,curbar2,EP,Mbar[];
   double curpr,Mprice[];
   bool flag,fd;
   
   
   /*������*/
   
   for(i=0;i<=Bars-1;i++)
   {zz[i]=0.0;zzL[i]=0.0;zzH[i]=0.0;}
   
   EP=ExtPoint;
   zzbarlow=iLowest(NULL,0,MODE_LOW,n,0);        
   zzbarhigh=iHighest(NULL,0,MODE_HIGH,n,0);     
   
   if(zzbarlow<zzbarhigh) {curbar=zzbarlow; curpr=Low[zzbarlow];}
   if(zzbarlow>zzbarhigh) {curbar=zzbarhigh; curpr=High[zzbarhigh];}
   if(zzbarlow==zzbarhigh){curbar=zzbarlow;curpr=funk1(zzbarlow, n);}
   
   ArrayResize(Mbar,ExtPoint);
   ArrayResize(Mprice,ExtPoint);
   j=0;
   endpr=curpr;
   endbar=curbar;
   Mbar[j]=curbar;
   Mprice[j]=curpr;
   
   EP--;
   if(curpr==Low[curbar]) flag=true;
   else flag=false;
   fl=flag;
 
   i=curbar+1;
   while(EP>0)
   {
    if(flag)
    {
     while(i<=Bars-1)
     {
     curbar1=iHighest(NULL,0,MODE_HIGH,n,i); 
     curbar2=iHighest(NULL,0,MODE_HIGH,n,curbar1); 
     if(curbar1==curbar2){curbar=curbar1;curpr=High[curbar];flag=false;i=curbar+1;j++;break;}
     else i=curbar2;
     }
     
     Mbar[j]=curbar;
     Mprice[j]=curpr;
     EP--;
     
    }
    
    if(EP==0) break;
    
    if(!flag) 
    {
     while(i<=Bars-1)
     {
     curbar1=iLowest(NULL,0,MODE_LOW,n,i); 
     curbar2=iLowest(NULL,0,MODE_LOW,n,curbar1); 
     if(curbar1==curbar2){curbar=curbar1;curpr=Low[curbar];flag=true;i=curbar+1;j++;break;}
     else i=curbar2;
     }
     
     Mbar[j]=curbar;
     Mprice[j]=curpr;
     EP--;
    }
   }
   /* ����������� ������ */
   if(Mprice[0]==Low[Mbar[0]])fd=true; else fd=false;
   for(k=0;k<=ExtPoint-1;k++)
   {
    if(k==0)
    {
     if(fd==true)
      {
       Mbar[k]=iLowest(NULL,0,MODE_LOW,Mbar[k+1]-Mbar[k],Mbar[k]);Mprice[k]=Low[Mbar[k]];endbar=minBars;
      }
     if(fd==false)
      {
       Mbar[k]=iHighest(NULL,0,MODE_HIGH,Mbar[k+1]-Mbar[k],Mbar[k]);Mprice[k]=High[Mbar[k]];endbar=minBars;
      }
    }
    if(k<ExtPoint-2)
    {
     if(fd==true)
      {
       Mbar[k+1]=iHighest(NULL,0,MODE_HIGH,Mbar[k+2]-Mbar[k]-1,Mbar[k]+1);Mprice[k+1]=High[Mbar[k+1]];
      }
     if(fd==false)
      {
       Mbar[k+1]=iLowest(NULL,0,MODE_LOW,Mbar[k+2]-Mbar[k]-1,Mbar[k]+1);Mprice[k+1]=Low[Mbar[k+1]];
      }
    }
    if(fd==true)fd=false;else fd=true;
    
    /* ��������� ZigZag'a */
    zz[Mbar[k]]=Mprice[k];
    //Print("zz_"+k,"=",zz[Mbar[k]]);
    if (k==0)
      {
       if (Mprice[k]>Mprice[k+1])
         {
          zzH[Mbar[k]]=Mprice[k];
         }
       else
         {
          zzL[Mbar[k]]=Mprice[k];
         }
      }
    else
      {
       if (Mprice[k]>Mprice[k-1])
         {
          zzH[Mbar[k]]=Mprice[k];
         }
       else
         {
          zzL[Mbar[k]]=Mprice[k];
         }
      
      }
   }
  
 } 
//------------------------------------------------------------------
//  ZigZag_Talex �����                                              
//------------------------------------------------------------------

//������������������������������������������������������������������������������������������������������������������������������
//  SQZZ by tovaroved.lv.  ������.  ��������������������������������������������������������������������������������������������
//������������������������������������������������������������������������������������������������������������������������������
double div(double a, double b){if(MathAbs(b)*10000>MathAbs(a)) return(a*1.0/b); else return(0);}
//=============================================================================================
double ray_value(double B1, double P1, double B2, double P2, double AAA){return(P1+( AAA -B1)*div(P2-P1,B2-B1));}
//=============================================================================================
datetime bar2time(int b){int t,TFsec=Period()*60; if(b<0) t=Time[0]-(b)*TFsec; else if(b>(Bars-1)) t=Time[Bars-1]-(b-Bars+1)*TFsec; else t=Time[b];  return(t);}
//=============================================================================================
int time2bar(datetime t){int b,t0=Time[0],TFsec=Period()*60; if(t>t0) b=(t0-t)/TFsec; else if(t<Time[Bars-2]) b=(Bars-2)+(Time[Bars-2]-t)/TFsec; else b=iBarShift(0,0,t); return(b);}
//=============================================================================================
void ZigZag_SQZZ(bool zzFill=true){  static int act_time=0,	H1=10000,L1=10000,H2=10000,H3=10000,H4=10000,L2=10000,L3=10000,L4=10000;	
	static double H1p=-1,H2p=-1,H3p=-1, H4p=-1,	L1p=10000,L2p=10000,L3p=10000,L4p=10000;
	int   mnm=1,tb,sH,sL,sX, i, a, barz, b,c, ii, H,L;	double val,x,Lp,Hp,k=0.;   if(Bars<100) return; if(1==2)bar2time(0);
	barz=Bars-4;int bb=barz;
	if(minBars==0)minBars=minSize;	if(minSize==0)minSize=minBars*3; tb=MathSqrt(minSize*minBars);
	mnm=tb;
	a=time2bar(act_time);	b=barz;//	Print(a," ",b," ",tb," ",barz," ",0);
	if(a>=0 && a<tb){
		ii=a;		a--;		L1+=a;		H1+=a;
		L2+=a;		H2+=a;		L3+=a;		H3+=a;
		if(!zzFill){
			for(i=barz; i>=a; i--)		{	zzH[i]=zzH[i-a];	zzL[i]=zzL[i-a];	}
			for(;i>=0;i--)  			{	zzH[i]=0;				zzL[i]=0;			}
		}
	}else{
		ii=barz;
		H1=ii+1; L1=ii;
		H2=ii+3; L2=ii+2;
		L2p=Low[L2];H2p=High[H2];	
		L1p=Low[L1];H1p=High[H1];
		H3=H2;	H3p=H2p;
		L3=L2;	L3p=L2p;
			
	}
	act_time=Time[1];

	for(c=0; ii>=0; c++, ii--)    {
//		if(c>tb) if(zzFill)	zz[ii+mnm]=MathMax(zzL[ii+mnm],zzH[ii+mnm]);
//		if(c>tb) if(zzFill)	zz[ii]=MathMax(zzL[ii],zzH[ii]);
		H=ii; L=ii;		Hp=	High[H];	Lp=	Low[L];
		//-------------------------------------------------------------------------------------
		if(H2<L2) {// ��� ��� ���� �������
			if( Hp>=H1p ){		H1=H;	H1p=Hp;
				if( H1p>H2p ){
					zzH[H2]=0;
					H1=H;	H1p=Hp;
					H2=H1;	H2p=H1p;
					L1=H1;	L1p=H1p;
					zzH[H2]=H2p;
				}
			}
			else
			if( Lp<=L1p ){		L1=L;	L1p=Lp;
				x=ray_value(L2,L2p,H2+(L2-H3)*0.5,H2p+(L2p-H3p)*0.5,L1);
				if( L1p<=L2p//����� �������� L1p<=L2p*0.75+H2p*0.25 ��� ����� ������ �������
				|| tb*tb*Point<(H2p-L1p)*(H2-L1)
				){ //�������� ��� Low
					L4=L3;	L4p=L3p;
					L3=L2;	L3p=L2p;
					L2=L1;	L2p=L1p;
					H1=L1;	H1p=L1p;
					zzL[L2]=L2p;
				}
			}
		}
		//--------------------------------------------------------------
		if(L2<H2) {// ��� ��� ���� �������
			if( Lp<=L1p ){		L1=L;	L1p=Lp;
				if( L1p<=L2p ){
					zzL[L2]=0;
					L1=L;	L1p=Lp;
					L2=L1;	L2p=L1p;
					H1=L1;	H1p=L1p;
					zzL[L2]=L2p;
				}
			}
			else
			if( Hp>=H1p ){		H1=H;	H1p=Hp;
				x=ray_value(H2,H2p,L2+0.5*(H2-L3),L2p+0.5*(H2p-L3p),H1);
				if( H1p>=H2p//����� � ���: H1p>=H2p*0.75+L2p*0.25
				|| tb*tb*Point<(H1p-L2p)*(L2-H1)
				){ //�������� ��� High
					H4=H3;	H4p=H3p;
					H3=H2;	H3p=H2p;
					H2=H1;	H2p=H1p;
					L1=H1;	L1p=H1p;
					zzH[H2]=H2p;
				}
			}

		}//--------------------------------------------------------------------------------
	}//for
	for(ii=bb-1; ii>=0; ii--) zz[ii]=MathMax(zzL[ii],zzH[ii]);
}//������������������������������������������������������������������������������������������������������������������������������
// SQZZ by tovaroved.lv. �����. 
//--------------------------------------------------------=======================================================================
/*-------------------------------------------------------------------+
/ ������ ��� ������ � ������� ���� (���� �� �������) ����� ��������� |
/ ����� ������������ � �������� �������.                             |
/-------------------------------------------------------------------*/
double funk1(int zzbarlow, int ExtDepth)
{
 double pr;
 int fbarlow,fbarhigh;
 
 fbarlow=iLowest(NULL,0,MODE_LOW,ExtDepth,zzbarlow);  
 fbarhigh=iHighest(NULL,0,MODE_HIGH,ExtDepth,zzbarlow);
 
 if(fbarlow>fbarhigh) pr=High[zzbarlow];
 if(fbarlow<fbarhigh) pr=Low[zzbarlow];
 if(fbarlow==fbarhigh)
 {
  fbarlow=iLowest(NULL,0,MODE_LOW,2*ExtDepth,zzbarlow);  
  fbarhigh=iHighest(NULL,0,MODE_HIGH,2*ExtDepth,zzbarlow);
  if(fbarlow>fbarhigh) pr=High[zzbarlow];
  if(fbarlow<fbarhigh) pr=Low[zzbarlow];
  if(fbarlow==fbarhigh)
  {
   fbarlow=iLowest(NULL,0,MODE_LOW,3*ExtDepth,zzbarlow);  
   fbarhigh=iHighest(NULL,0,MODE_HIGH,3*ExtDepth,zzbarlow);
   if(fbarlow>fbarhigh) pr=High[zzbarlow];
   if(fbarlow<fbarhigh) pr=Low[zzbarlow];
  }
 }
 return(pr);
}
//--------------------------------------------------------
// �����. 
//--------------------------------------------------------


//--------------------------------------------------------
// ��������� i-vts . ������. 
//--------------------------------------------------------
//+------------------------------------------------------------------+
//|                                                        i-VTS.mq4 |
//|                                                    ����� & KimIV |
//|                                              http://www.kimiv.ru |
//|                                                                  |
//|  06.12.2005  ��������� VTS                                       |
//+------------------------------------------------------------------+
//
// ���� ��������� ����� ��� ������� � MQL �� MQ4
//
void i_vts() //
  {
   int    LoopBegin, sh;

 	if (NumberOfBars==0) LoopBegin=Bars-1;
   else LoopBegin=NumberOfBars-1;
   LoopBegin=MathMin(Bars-25, LoopBegin);

   for (sh=LoopBegin; sh>=0; sh--)
     {
      GetValueVTS("", 0, NumberOfVTS, sh);
      ha[sh]=ms[0];
      la[sh]=ms[1];
     }
  }

void i_vts1() //
  {
   int    LoopBegin, sh;

 	if (NumberOfBars==0) LoopBegin=Bars-1;
   else LoopBegin=NumberOfBars-1;
   LoopBegin=MathMin(Bars-25, LoopBegin);

   for (sh=LoopBegin; sh>=0; sh--)
     {
      GetValueVTS("", 0, NumberOfVTS1, sh);
      ham[sh]=ms[0];
      lam[sh]=ms[1];
     }
  }
//+------------------------------------------------------------------+
//------- ���������� ������� ������� ---------------------------------
//+------------------------------------------------------------------+
//| ���������:                                                       |
//|   sym - ������������ �����������                                 |
//|   tf  - ��������� (���������� �����)                             |
//|   ng  - ����� ������                                             |
//|   nb  - ����� ����                                               |
//|   ms  - ������ ��������                                          |
//+------------------------------------------------------------------+
void GetValueVTS(string sym, int tf, int ng, int nb)
  {
   if (sym=="") sym=Symbol();
   double f1, f2, s1, s2;

   f1=iClose(sym, tf, nb)-3*iATR(sym, tf, 10, nb);
   f2=iClose(sym, tf, nb)+3*iATR(sym, tf, 10, nb);
   for (int i=1; i<=ng; i++)
     {
      s1=iClose(sym, tf, nb+i)-3*iATR(sym, tf, 10, nb+i);
      s2=iClose(sym, tf, nb+i)+3*iATR(sym, tf, 10, nb+i);
      if (f1<s1) f1=s1;
      if (f2>s2) f2=s2;
     }
    ms[0]=f2;   // ������� �����
    ms[1]=f1;   // ������ �����
  }
//+------------------------------------------------------------------+
//--------------------------------------------------------
// ��������� i-vts . �����. 
//--------------------------------------------------------

//--------------------------------------------------------
// ��������� ������ �����������. ������. 
//--------------------------------------------------------
void info_TF()
  {
   string info, info1, info2, txt;
   int i,pips;

   openTF[0]=iOpen(NULL,PERIOD_MN1,0);
   closeTF[0]=iClose(NULL,PERIOD_MN1,0);
   lowTF[0]=iLow(NULL,PERIOD_MN1,0);
   highTF[0]=iHigh(NULL,PERIOD_MN1,0);
   
   openTF[1]=iOpen(NULL,PERIOD_W1,0);
   closeTF[1]=iClose(NULL,PERIOD_W1,0);
   lowTF[1]=iLow(NULL,PERIOD_W1,0);
   highTF[1]=iHigh(NULL,PERIOD_W1,0);
   
   openTF[2]=iOpen(NULL,PERIOD_D1,0);
   closeTF[2]=iClose(NULL,PERIOD_D1,0);
   lowTF[2]=iLow(NULL,PERIOD_D1,0);
   highTF[2]=iHigh(NULL,PERIOD_D1,0);
   
   openTF[3]=iOpen(NULL,PERIOD_H4,0);
   closeTF[3]=iClose(NULL,PERIOD_H4,0);
   lowTF[3]=iLow(NULL,PERIOD_H4,0);
   highTF[3]=iHigh(NULL,PERIOD_H4,0);
   
   openTF[4]=iOpen(NULL,PERIOD_H1,0);
   closeTF[4]=iClose(NULL,PERIOD_H1,0);
   lowTF[4]=iLow(NULL,PERIOD_H1,0);
   highTF[4]=iHigh(NULL,PERIOD_H1,0);
   
   info="|  ";

   for (i=0;i<5;i++)
     {
      pips=(highTF[i]-lowTF[i])/Point;
      if (pips>0)
        {
         if (openTF[i]>closeTF[i]) {txt=" < ";}
         else if (openTF[i]==closeTF[i]) {txt=" = ";}
         else if (openTF[i]<closeTF[i]) {txt=" > ";}
         info=info + TF[i] + txt + DoubleToStr(pips,0) + "   " +  DoubleToStr((closeTF[i]-lowTF[i])/(pips*Point),3) + " |  ";
        }
     }

   if (afrl[0]>0)
     {
      info1=info+Period_tf+"  "+DoubleToStr(100*MathAbs(afrh[1]-afrl[0])/afrh[1],2)+" %";
     }
   else
     {
      info1=info+Period_tf+"  "+DoubleToStr(100*MathAbs(afrh[0]-afrl[1])/afrl[1],2)+" %";
     }

   if (RangeForPointD>0 && vPatOnOff == 1) info2="  |  " + DoubleToStr(LevelForDmin,Digits) + " < D < " + DoubleToStr(LevelForDmax,Digits);

   Comment(info1,"\n",vBullBear + " " + vNamePattern + info2);
   close_TF=Close[0];
  }
//--------------------------------------------------------
// ��������� ������ �����������. �����. 
//--------------------------------------------------------


//--------------------------------------------------------
// ��������� ������� ��������. ������. 
//--------------------------------------------------------
void arrResize(int size)
  {
   ArrayResize(fi,size);
   ArrayResize(fitxt,size);
   ArrayResize(fitxt100,size);
  }
//--------------------------------------------------------
// ��������� ������� ��������. ������. 
//--------------------------------------------------------


//--------------------------------------------------------
// ������� ������� � �������. ������. 
//--------------------------------------------------------
void array_()
  {
   for (int i=0; i<65; i++)
     {
      numberFibo            [i]=0;
      numberPesavento       [i]=0;
      numberGartley         [i]=0;
      numberGilmorQuality   [i]=0;
      numberGilmorGeometric [i]=0;
      numberGilmorHarmonic  [i]=0;
      numberGilmorArithmetic[i]=0;
      numberGilmorGoldenMean[i]=0;
      numberSquare          [i]=0;
      numberCube            [i]=0;
      numberRectangle       [i]=0;
      numberExt             [i]=0;
     }

   number                [0]=0.111;
   numbertxt             [0]=".111";
   numberCube            [0]=1;

   number                [1]=0.125;
   numbertxt             [1]=".125";
   numberMix             [1]=1;
   numberGilmorHarmonic  [1]=1;

   number                [2]=0.146;
   numbertxt             [2]=".146";
   numberFibo            [2]=1;
   numberGilmorGeometric [2]=1;

   number                [3]=0.167;
   numbertxt             [3]=".167";
   numberGilmorArithmetic[3]=1;

   number                [4]=0.177;
   numbertxt             [4]=".177";
   numberGilmorHarmonic  [4]=1;
   numberSquare          [4]=1;

   number                [5]=0.186;
   numbertxt             [5]=".186";
   numberGilmorGeometric [5]=1;

   number                [6]=0.192;
   numbertxt             [6]=".192";
   numberCube            [6]=1;

   number                [7]=0.2;
   numbertxt             [7]=".2";
   numberRectangle       [7]=1;

   number                [8]=0.236;
   numbertxt             [8]=".236";
   numberFibo            [8]=1;
   numberMix             [8]=1;
   numberGilmorGeometric [8]=1;
   numberGilmorGoldenMean[8]=1;

   number                [9]=0.25;
   numbertxt             [9]=".25";
   numberPesavento       [9]=1;
   numberGilmorQuality   [9]=1;
   numberGilmorHarmonic  [9]=1;
   numberSquare          [9]=1;

   number                [10]=0.3;
   numbertxt             [10]=".3";
   numberGilmorGeometric [10]=1;
   numberGilmorGoldenMean[10]=1;

   number                [11]=0.333;
   numbertxt             [11]=".333";
   numberGilmorArithmetic[11]=1;
   numberCube            [11]=1;

   number                [12]=0.354;
   numbertxt             [12]=".354";
   numberGilmorHarmonic  [12]=1;
   numberSquare          [12]=1;

   number                [13]=0.382;
   numbertxt             [13]=".382";
   numberFibo            [13]=1;
   numberPesavento       [13]=1;
   numberGartley         [13]=1;
   numberGilmorQuality   [13]=1;
   numberGilmorGeometric [13]=1;

   number                [14]=0.447;
   numbertxt             [14]=".447";
   numberGartley         [14]=1;
   numberRectangle       [14]=1;

   number                [15]=0.486;
   numbertxt             [15]=".486";
   numberGilmorGeometric [15]=1;
   numberGilmorGoldenMean[15]=1;

   number                [16]=0.5;
   numbertxt             [16]=".5";
   numberFibo            [16]=1;
   numberPesavento       [16]=1;
   numberGartley         [16]=1;
   numberGilmorQuality   [16]=1;
   numberGilmorHarmonic  [16]=1;
   numberSquare          [16]=1;

   number                [17]=0.526;
   numbertxt             [17]=".526";
   numberGilmorGeometric [17]=1;

   number                [18]=0.577;
   numbertxt             [18]=".577";
   numberGilmorArithmetic[18]=1;
   numberCube            [18]=1;

   number                [19]=0.618;
   numbertxt             [19]=".618";
   numberFibo            [19]=1;
   numberPesavento       [19]=1;
   numberGartley         [19]=1;
   numberGilmorQuality   [19]=1;
   numberGilmorGeometric [19]=1;
   numberGilmorGoldenMean[19]=1;

   number                [20]=0.667;
   numbertxt             [20]=".667";
   numberGilmorQuality   [20]=1;
   numberGilmorArithmetic[20]=1;

   number                [21]=0.707;
   numbertxt             [21]=".707";
   numberPesavento       [21]=1;
   numberGartley         [21]=1;
   numberGilmorHarmonic  [21]=1;
   numberSquare          [21]=1;

   number                [22]=0.764;
   numbertxt             [22]=".764";
   numberFibo            [22]=1;

   number                [23]=0.786;
   numbertxt             [23]=".786";
   numberPesavento       [23]=1;
   numberGartley         [23]=1;
   numberGilmorQuality   [23]=1;
   numberGilmorGeometric [23]=1;
   numberGilmorGoldenMean[23]=1;

   number                [24]=0.809;
   numbertxt             [24]=".809";
   numberExt             [24]=1;

   number                [25]=0.841;
   numbertxt             [25]=".841";
   numberPesavento       [25]=1;

   number                [26]=0.854;
   numbertxt             [26]=".854";
   numberFibo            [26]=1;
   numberMix             [26]=1;

   number                [27]=0.874;
   numbertxt             [27]=".874";
   numberExt             [27]=1;

   number                [28]=0.886;
   numbertxt             [28]=".886";
   numberGartley         [28]=1;

   number                [29]=1.0;
   numbertxt             [29]="1.";
   numberFibo            [29]=1;
   numberPesavento       [29]=1;
   numberGartley         [29]=1;
   numberGilmorQuality   [29]=1;
   numberGilmorGeometric [29]=1;

   number                [30]=1.128;
   numbertxt             [30]="1.128";
   numberPesavento       [30]=1;
   numberGartley         [30]=1;

   number                [31]=1.236;
   numbertxt             [31]="1.236";
   numberFibo            [31]=1;

   number                [32]=1.272;
   numbertxt             [32]="1.272";
   numberPesavento       [32]=1;
   numberGartley         [32]=1;
   numberGilmorQuality   [32]=1;
   numberGilmorGeometric [32]=1;
   numberGilmorGoldenMean[32]=1;

   number                [33]=1.309;
   numbertxt             [33]="1.309";
   numberExt             [33]=1;

   number                [34]=1.414;
   numbertxt             [34]="1.414";
   numberPesavento       [34]=1;
   numberGartley         [34]=1;
   numberGilmorHarmonic  [34]=1;
   numberSquare          [34]=1;

   number                [35]=1.5;
   numbertxt             [35]="1.5";
//   numberPesavento       [35]=1;
   numberGilmorArithmetic[35]=1;

   number                [36]=1.618;
   numbertxt             [36]="1.618";
   numberFibo            [36]=1;
   numberPesavento       [36]=1;
   numberGartley         [36]=1;
   numberGilmorQuality   [36]=1;
   numberGilmorGeometric [36]=1;
   numberGilmorGoldenMean[36]=1;

   number                [37]=1.732;
   numbertxt             [37]="1.732";
   numberMix             [37]=1;
   numberGilmorQuality   [37]=1;
   numberGilmorArithmetic[37]=1;
   numberCube            [37]=1;

   number                [38]=1.75;
   numbertxt             [38]="1.75";
   numberGilmorQuality   [38]=1;

   number                [39]=1.902;
   numbertxt             [39]="1.902";
   numberMix             [39]=1;
   numberGilmorGeometric [39]=1;

   number                [40]=2.0;
   numbertxt             [40]="2.";
   numberPesavento       [40]=1;
   numberGartley         [40]=1;
   numberGilmorQuality   [40]=1;
   numberGilmorHarmonic  [40]=1;
   numberSquare          [40]=1;

   number                [41]=2.058;
   numbertxt             [41]="2.058";
   numberGilmorGeometric [41]=1;
   numberGilmorGoldenMean[41]=1;

   number                [42]=2.236;
   numbertxt             [42]="2.236";
   numberGartley         [42]=1;
   numberGilmorQuality   [42]=1;
   numberRectangle       [42]=1;

   number                [43]=2.288;
   numbertxt             [43]="2.288";
   numberExt             [43]=1;

   number                [44]=2.5;
   numbertxt             [44]="2.5";
   numberGilmorQuality   [44]=1;

   number                [45]=2.618;
   numbertxt             [45]="2.618";
   numberPesavento       [45]=1;
   numberGartley         [45]=1;
   numberGilmorQuality   [45]=1;
   numberGilmorGeometric [45]=1;
   numberGilmorGoldenMean[45]=1;

   number                [46]=2.828;
   numbertxt             [46]="2.828";
   numberGilmorHarmonic  [46]=1;
   numberSquare          [46]=1;

   number                [47]=3.0;
   numbertxt             [47]="3.0";
   numberGilmorQuality   [47]=1;
   numberGilmorArithmetic[47]=1;
   numberCube            [47]=1;

   number                [48]=3.142;
   numbertxt             [48]="3.142";
   numberGartley         [48]=1;

   number                [49]=3.236;
   numbertxt             [49]="3.236";
   numberExt             [49]=1;

   number                [50]=3.33;
   numbertxt             [50]="3.33";
   numberGilmorQuality   [50]=1;
   numberGilmorGeometric [50]=1;
   numberGilmorGoldenMean[50]=1;
   numberExt             [50]=1;

   number                [51]=3.464;
   numbertxt             [51]="3.464";
   numberExt             [51]=1;

   number                [52]=3.618;
   numbertxt             [52]="3.618";
   numberGartley         [52]=1;

   number                [53]=4.0;
   numbertxt             [53]="4.";
   numberPesavento       [53]=1;
   numberGilmorHarmonic  [53]=1;
   numberSquare          [53]=1;

   number                [54]=4.236;
   numbertxt             [54]="4.236";
   numberFibo            [54]=1;
   numberGilmorQuality   [54]=1;
   numberGilmorGeometric [54]=1;
   numberExt             [54]=1;

   number                [55]=4.472;
   numbertxt             [55]="4.472";
   numberExt             [55]=1;

   number                [56]=5.0;
   numbertxt             [56]="5.";
   numberRectangle       [56]=1;

   number                [57]=5.2;
   numbertxt             [57]="5.2";
   numberCube            [57]=1;

   number                [58]=5.388;
   numbertxt             [58]="5.388";
   numberGilmorGeometric [58]=1;

   number                [59]=5.657;
   numbertxt             [59]="5.657";
   numberGilmorHarmonic  [59]=1;
   numberSquare          [59]=1;

   number                [60]=6.0;
   numbertxt             [60]="6.";
   numberGilmorArithmetic[60]=1;

   number                [61]=6.854;
   numbertxt             [61]="6.854";
   numberGilmorQuality   [61]=1;
   numberGilmorGeometric [61]=1;

   number                [62]=8.0;
   numbertxt             [62]="8.";
   numberGilmorHarmonic  [62]=1;

   number                [63]=9.0;
   numbertxt             [63]="9.";
   numberCube            [63]=1;
/*
   number                []=;
   numbertxt             []=;

// ExtFiboType=0
   numberFibo            []=;
// 0
   numberPesavento       []=;
// 1
   numberGartley         []=;
// 2
   numberMix             []=;
// 3
   numberGilmorQuality   []=;
// 4
   numberGilmorGeometric []=;
// 5
   numberGilmorHarmonic  []=;
// 6
   numberGilmorArithmetic[]=;
// 7
   numberGilmorGoldenMean[]=;
// 8
   numberSquare          []=;
// 9
   numberCube            []=;
// 10
   numberRectangle       []=;
// 11
   numberExt             []=;
*/
  }
//--------------------------------------------------------
// ������� ������� � �������. �����. 
//--------------------------------------------------------


//--------------------------------------------------------
// ����������� �������� � ����� ����� ��� ��������� ���������. ������. 
//--------------------------------------------------------
void Pesavento_patterns()
  {
   if (ExtFiboType==1)
     {
      switch (ExtFiboChoice)
        {
         case 0  : {search_number(numberPesavento, ExtPesavento)        ;break;}
         case 1  : {search_number(numberGartley, ExtGartley886)         ;break;}
         case 2  : {search_number(numberGartley, ExtGartley886)         ;break;}
         case 3  : {search_number(numberGilmorQuality, ExtPesavento)    ;break;}
         case 4  : {search_number(numberGilmorGeometric, ExtPesavento)  ;break;}
         case 5  : {search_number(numberGilmorHarmonic, ExtPesavento)   ;break;}
         case 6  : {search_number(numberGilmorArithmetic, ExtPesavento) ;break;}
         case 7  : {search_number(numberGilmorGoldenMean, ExtPesavento) ;break;}
         case 8  : {search_number(numberSquare, ExtPesavento)           ;break;}
         case 9  : {search_number(numberCube, ExtPesavento)             ;break;}
         case 10 : {search_number(numberRectangle, ExtPesavento)        ;break;}
         case 11 : {search_number(numberExt, ExtPesavento)              ;break;}
        }
      }
    else
      {
       search_number(numberFibo, ExtPesavento);
      }

  }
//--------------------------------------------------------
// ����������� �������� � ����� ����� ��� ��������� ���������. �����. 
//--------------------------------------------------------

//--------------------------------------------------------
// ����� ����� ��� ��������� ���������. ������. 
//--------------------------------------------------------
void search_number(int arr[], color cPattern)
  {
   int ki;
   colorPPattern=ExtNotFibo;
   if (ExtFiboChoice!=2)
     {
      if (ExtDeltaType==2) for (ki=kiPRZ;ki<=63;ki++)
                             {
                              if (arr[ki]>0)
                                {
                                 if (MathAbs((number[ki]-kj)/number[ki])<=ExtDelta)
                                   {kk=number[ki]; txtkk=numbertxt[ki]; k2=-1; colorPPattern=cPattern; break;}
                                }
                             }

      if (ExtDeltaType==1) for (ki=kiPRZ;ki<=63;ki++)
                             {
                              if (arr[ki]>0)
                                {
                                 if (MathAbs(number[ki]-kj)<=ExtDelta)
                                   {kk=number[ki]; txtkk=numbertxt[ki]; k2=-1; colorPPattern=cPattern; break;}
                                }
                             }
     }
   else
     {
      if (ExtDeltaType==2) for (ki=kiPRZ;ki<=63;ki++)
                             {
                              if (arr[ki]>0)
                                {
                                 if (MathAbs((number[ki]-kj)/number[ki])<=ExtDelta)
                                   {kk=number[ki]; txtkk=numbertxt[ki]; k2=-1; colorPPattern=cPattern; break;}
                                }
                              else if (numberMix[ki]>0)
                                     if (MathAbs((number[ki]-kj)/number[ki])<=ExtDelta)
                                       {kk=number[ki]; txtkk=numbertxt[ki]; k2=-1; colorPPattern=ExtPesavento; break;}
                             }

      if (ExtDeltaType==1) for (ki=kiPRZ;ki<=63;ki++)
                             {
                              if (arr[ki]>0)
                                {
                                 if (MathAbs(number[ki]-kj)<=ExtDelta)
                                   {kk=number[ki]; txtkk=numbertxt[ki]; k2=-1; colorPPattern=cPattern; break;}
                                }
                              else if (numberMix[ki]>0)
                                     if (MathAbs(number[ki]-kj)<=ExtDelta)
                                       {kk=number[ki]; txtkk=numbertxt[ki]; k2=-1; colorPPattern=ExtPesavento; break;}
                             }
     }
  }
//--------------------------------------------------------
// ����� ����� ��� ��������� ���������. �����. 
//--------------------------------------------------------

//--------------------------------------------------------
// �������� ��������� �� ����������� �����. ������. 
//--------------------------------------------------------
void _SendMail(string subject, string some_text)
  {
   SendMail(subject, some_text);
  }
//--------------------------------------------------------
// �������� ��������� �� ����������� �����. �����. 
//--------------------------------------------------------

