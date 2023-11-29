#property copyright "Sergey Vasilev"
#property link "http://www.mql5.com/enzzo"
#property library

#include <Object.mqh>

class html_file : public CObject{
int handle_;

public:
    html_file() = delete;
    html_file(string file_name, string title, string style = "styles/default.css");
   ~html_file();

   void msg(string text, string style = "text");
   void msg_ln(string text, string style = "text");
   void msg_time(string text, string style = "text");
   void msg_time_ln(string text, string style = "text");
};

html_file::html_file(string file_name,
                     string title,
                     string style = "styles/default.css"){
    handle_ = FileOpen(file_name, FILE_CSV|FILE_WRITE, " ");
    if(handle_ > 0){
        FileWrite(handle_,
                  "<html><head><title>", title,
                  "</title><link rel=stylesheet href=", style, " type=text/css>",
                  "</head><body id=body><div align-center><h3 id=title>", title,
                  "</h3></div><hr noshade id=hr");
    }
    else{
        Print("generateHTML library: error while creating html file");
    }
}

html_file::~html_file(){
    if(handle_ > 0){
        FileWrite(handle_, "</body></html>");
        FileClose(handle_);
    }
}