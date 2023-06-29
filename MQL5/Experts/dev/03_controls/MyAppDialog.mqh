#property copyright     "Sergey Vasilev"
#property link          "https://www.mql5.com/ru/users/enzzo"
#property version       "1.00"
#property description   "Класс CMyAppDialog, унаследованный от CAppDialog"
#property description   "Добавлены методы для установки цвета фона и заголовка"

#include <Controls\Dialog.mqh>

class CMyAppDialog : public CAppDialog{
public:
    void    ColorBackground(const color clr);
    color   ColorCaption();
    void    ColorCaption(const color clr);

public:
    CMyAppDialog(){};
   ~CMyAppDialog(){};
};

void CMyAppDialog::ColorBackground(const color clr){
    string prefix = Name();
    int total = ControlsTotal();

    for(int i = 0; i < total; ++i){
        CWnd* obj = Control(i);
        string name = obj.Name();

        if(name == prefix + "Client"){
            CWndClient* wndclient = (CWndClient*) obj;
            wndclient.ColorBackground(clr);
            ChartRedraw();
            return;
        }
    }
}

void CMyAppDialog::ColorCaption(const color clr){
    string prefix = Name();
    int total = ControlsTotal();

    for(int i = 0; i < total; ++i){
        CWnd* obj = Control(i);
        string name = obj.Name();

        if(name == prefix + "Caption"){
            CEdit* edit = (CEdit*) obj;
            edit.ColorBackground(clr);
            ChartRedraw();
            return;
        }
    }
}

color CMyAppDialog::ColorCaption(){
    string prefix = Name();
    int total = ControlsTotal();

    for(int i = 0; i < total; ++i){
        CWnd* obj = Control(i);
        string name = obj.Name();

        if(name == prefix + "Caption"){
            CEdit* edit = (CEdit*) obj;
            return edit.ColorBackground(clrNONE);
        }
    }
    return clrNONE;
}