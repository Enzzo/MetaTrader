// ---------------------------------------------------------------------------
//  ������������ ����� �������� - �� ����������� �� N ����.
//
//  ������ ����������:
//  0 - ������� �������.
//  1 - ������ �������.
//  2 - �������� ������.
// ---------------------------------------------------------------------------

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1  Blue
#property indicator_color2  Blue
//#property indicator_color3  DarkViolet
#property indicator_style3  STYLE_DOT

// ����� ��������������� �������.
extern int HISTORY_DEPTH = 20;

// ������ ����������.
double buf_up[], buf_dn[] ;//,buf_md[]

// �������������.
int init() {
  IndicatorShortName(StringConcatenate(
    "DONCHIAN CHANNEL(", HISTORY_DEPTH, ")"));
  IndicatorDigits(Digits);
    
  SetIndexBuffer(0, buf_up);
  SetIndexBuffer(1, buf_dn);
 // SetIndexBuffer(2, buf_md);
  
  SetIndexLabel(0, "UPPER BOUND");
  SetIndexLabel(1, "LOWER BOUND");
  //SetIndexLabel(2, "MIDDLE LINE");
  
  return(0);
}

// ������� ����.
int start() {
  int i;
  
  for(i = Bars - IndicatorCounted() - 1; i >= 0; i--) {
    buf_up[i] = High[iHighest(NULL, 0, MODE_HIGH, HISTORY_DEPTH, i)];
    buf_dn[i] = Low [iLowest (NULL, 0, MODE_LOW,  HISTORY_DEPTH, i)];
   // buf_md[i] = 0.5 * (buf_up[i] + buf_dn[i]);
  }
  
  return(0);
}

