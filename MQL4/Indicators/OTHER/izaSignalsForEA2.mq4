//+------------------------------------------------------------------+
//|                                             izaSignalsForEA2.mq4 |
//|                                                  izzat12@mail.ru |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "izzat12@mail.ru"
#property link      "https://www.mql5.com/ru/users/izzatilla"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_minimum -1
#property indicator_maximum 1
#property indicator_buffers 3
#property indicator_plots   3
#property indicator_label1  "Long"
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  clrLime
#property indicator_style1  STYLE_SOLID
#property indicator_width1  3
#property indicator_label2  "Short"
#property indicator_type2   DRAW_HISTOGRAM
#property indicator_color2  clrOrange
#property indicator_style2  STYLE_SOLID
#property indicator_width2  3
#property indicator_label3  "Flat"
#property indicator_type3   DRAW_HISTOGRAM
#property indicator_color3  clrGray
#property indicator_style3  STYLE_SOLID
#property indicator_width3  3
#property indicator_level1  0.0

input string   symbol         = "";    //Signal symbol

datetime       AllowDate      = D'30.12.2025';

double         LongBuffer[];
double         ShortBuffer[];
double         FlatBuffer[];

string         url            = "http://192.168.1.201/generate.php?";
string         obj_prefix     = "iza_";
datetime       ud             = 0;

struct sRow
{
   string   symbol;
   datetime date;
   string   signal;
   double   value;
};

int OnInit()
{
   if(TimeCurrent()>AllowDate)
   {  
      Alert("Indicator is not activated! E-mail: izzat12@mail.ru"); 
      return(INIT_FAILED); 
   }

   ud=0;
   IndicatorDigits(2);
   SetIndexBuffer(0,LongBuffer);
   SetIndexBuffer(1,ShortBuffer);
   SetIndexBuffer(2,FlatBuffer);
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   if(!IsTesting() || reason==3) ObjectsDeleteAll(0,obj_prefix);
   Comment("");
   ud=0;
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   if(prev_calculated==rates_total) return(rates_total);
   
   if(ud==0 || TimeToString(TimeCurrent(),TIME_DATE)!=TimeToString(ud,TIME_DATE))
   {
      bool res;
      sRow row[];
      string _symbol,text;
   
      MqlDateTime sd,ed;
      string start_date;
      string end_date;
      
      TimeToStruct(Time[0],sd);
      start_date  = IntegerToString(sd.day)+"."+IntegerToString(sd.mon)+"."+IntegerToString(sd.year);
      TimeToStruct(Time[0],ed);
      end_date    = IntegerToString(ed.day)+"."+IntegerToString(ed.mon)+"."+IntegerToString(ed.year);
      
      if(symbol=="") _symbol=_Symbol; else _symbol=symbol;
      string request_url = url+"start_date="+start_date+"&"+ "end_date="+end_date+"&symbol="+_symbol; Print(request_url);
                           
      res = GrabWeb(request_url,text);
               
      if(res)
      {
         convertResult(text,row);
         for(int i=0;i<ArraySize(row);i++)
         {
            if(row[i].date==iTime(_Symbol,PERIOD_D1,0))
            {
               if(row[i].signal=="long")  LongBuffer[0]  = row[i].value;
               if(row[i].signal=="short") ShortBuffer[0] = row[i].value;
               if(row[i].signal=="no")    FlatBuffer[0]  = row[i].value;
            }
         }
         ud=iTime(_Symbol,PERIOD_D1,0);
      }      
   }
   else
   {
      LongBuffer[0]  = LongBuffer[1];
      ShortBuffer[0] = ShortBuffer[1];
      FlatBuffer[0]  = FlatBuffer[1];
   }
   return(rates_total);
}
//+------------------------------------------------------------------+
bool convertResult(string in, sRow& rowout[])
{
   string out[], row[], t="";
   int l;
   
   StringReplace(in,"\n","");
   StringReplace(in,"<table>","");
   StringReplace(in,"</table>","");
   StringReplace(in,"<tbody>","");
   StringReplace(in,"</tbody>","");
   StringReplace(in,"<td>","");
   StringReplace(in,"</td>","|");
   StringReplace(in,"<tr>","");
   StringReplace(in,"</tr>",";");
      
   StringSplit(in,StringGetCharacter(";",0),out);
   
   for(int i=0;i<ArraySize(out);i++)
   {
      StringTrimLeft(out[i]);
      StringTrimRight(out[i]);
      Print(out[i]);   

      StringSplit(out[i],StringGetCharacter("|",0),row);
      
      if(ArraySize(row)>=4)
      {
         l = ArraySize(rowout);
         ArrayResize(rowout,l+1);
         StringReplace(row[0],"/","");
         rowout[l].symbol=row[0]; Print(row[0]," ",rowout[l].symbol);
         rowout[l].date=StringToTime(row[1]); Print(row[1]," ",rowout[l].date);
         rowout[l].signal=row[2];
         StringReplace(row[3],",",".");
         rowout[l].value=StringToDouble(row[3]);
      }
   }
      
   return(true);
}

bool bWinInetDebug = true;
int hSession_IEType;
int hSession_Direct;
int Internet_Open_Type_Preconfig = 0;
int Internet_Open_Type_Direct = 1;
int Internet_Open_Type_Proxy = 3;
int Buffer_LEN = 512;

#import "wininet.dll"
int InternetAttemptConnect (int x);
int InternetOpenW(string sAgent, int lAccessType, string sProxyName = "", string sProxyBypass = "", int lFlags = 0);
int InternetOpenUrlW(int hInternetSession, string sUrl, string sHeaders = "", int lHeadersLength = 0, int lFlags = 0, int lContext = 0);
int InternetReadFile(int hFile, int& sBuffer[], int lNumBytesToRead, int& lNumberOfBytesRead[]);
int InternetCloseHandle(int hInet);
#import

bool GrabWeb(string request, string& webpage)
{
   if(!IsDllsAllowed()) { Comment("DLL's are forbidden!"); return(false); }
   int rv = InternetAttemptConnect(0);
   
   if(rv != 0) { Comment("Internet Attempt error!"); return(false); }
   
   int hInternetSession = InternetOpenW("Microsoft Internet Explorer", 0, "", "", 0);
   
   if(hInternetSession <= 0) { Comment("Internet Open error!"); return(0); }
   
   int hURL = InternetOpenUrlW(hInternetSession, request, "", 0, 0, 0);
   
   if(hURL <= 0) { Comment("Internet Open Url error!"); InternetCloseHandle(hInternetSession); return(false); }      
   
   int cBuffer[256];
   int dwBytesRead[1]; 
   string TXT = "";
   
   while(!IsStopped())
   {
      bool bResult = InternetReadFile(hURL, cBuffer, 1024, dwBytesRead);
      if(dwBytesRead[0] == 0) break;
      string text = "";   
      
      for(int i = 0; i < 256; i++)
      {
         text += CharToStr((uchar)(cBuffer[i] & 0x000000FF));
        	if(StringLen(text) == dwBytesRead[0]) break;
     	   text += CharToStr((uchar)((cBuffer[i] >> 8) & 0x000000FF));
     	   if(StringLen(text) == dwBytesRead[0]) break;
         text += CharToStr((uchar)((cBuffer[i] >> 16) & 0x000000FF));
         if(StringLen(text) == dwBytesRead[0]) break;
         text += CharToStr((uchar)((cBuffer[i] >> 24) & 0x000000FF));
      }
      TXT += text;
   }
   
   webpage = TXT;
   
   InternetCloseHandle(hInternetSession);
   return(true);
}