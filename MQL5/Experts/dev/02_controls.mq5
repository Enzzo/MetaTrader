#property copyright "Sergey Vasilev"
#property link      "https://www.mql5.com/ru/users/enzzo"
#property version   "1.00"
#property description "Панель меняет свою прозрачность при перемещении"

#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>

#define XRGB(r, g, b)   (uchar(r)<<16 | (uchar(g)<<8) | uchar(b))
#define GETRGB(clr)     ((clr) & 0xFFFFFFFF)

#define INDENT_LEFT         (11)
#define INDENT_TOP          (11)
#define CONTROLS_GAP_X      (5)
#define BUTTON_WIDTH        (100)
#define BUTTON_HEIGHT       (20)

class CLivePanelAndButton : public CAppDialog{
private:
    CButton m_button1, m_button2;

public:
    CLivePanelAndButton(){};
    ~CLivePanelAndButton(){};

    virtual bool Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2) override;

    virtual bool OnDialogDragStart() override;
    virtual bool OnDialogDragProcess() override;
    virtual bool OnDialogDragEnd() override;
    virtual bool OnEvent(const int id, const long &lparam, const double &dparam, const string &sparam) override;

protected:
    bool CreateButton1();
    bool CreateButton2();

    void OnClickButton1();
    void OnClickButton2();
};

CLivePanelAndButton ExtDialog;

int OnInit(){

    if(!ExtDialog.Create(0, "Live Panel", 0, 20, 20, 360, 324)){
        return (INIT_FAILED);
    }

    ExtDialog.Run();

    return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
    ExtDialog.Destroy(reason);
}

void OnChartEvent(  const int id,
                    const long& lparam,
                    const double& dparam,
                    const string& sparam){
    ExtDialog.ChartEvent(id, lparam, dparam, sparam);

}

bool CLivePanelAndButton::Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2){
    if(!CAppDialog::Create(chart, name, subwin, x1, y1, x2, y2)){
        return (false);
    }
    if(!CreateButton1()){
        return (false);
    }
    if(!CreateButton2()){
        return (false);
    }
    return (true);
}

//--- ищем только один объект - Back, и динамически меняем его цвет
//--- при помощ макросов GETRGB и XRGB
bool CLivePanelAndButton::OnDialogDragStart(){
    string prefix = Name();
    
    // int total = ExtDialog.ControlsTotal();
    int total = ControlsTotal();

    for(int i = 0; i < total; ++i){
        // CWnd* obj = ExtDialog.Control(i);
        CWnd* obj = Control(i);

        string name = obj.Name();
        
        if(name == prefix+"Border"){
            CPanel* panel = (CPanel*)obj;
            panel.ColorBackground(clrNONE);
            ChartRedraw();
        }

        if(name == prefix + "Back"){
            CPanel* panel = (CPanel*) obj;
            // color clr = (color) GETRGB(XRGB(rand()%255, rand()%255, rand()%255));
            // panel.ColorBorder(clr);
            panel.ColorBackground(clrNONE);
            ChartRedraw();
        }

        if(name == prefix + "Client"){
            CWndClient* wndclient = (CWndClient*) obj;
            wndclient.ColorBackground(clrNONE);
            wndclient.ColorBorder(clrNONE);

            int client_total = wndclient.ControlsTotal();
            for(int j = 0; j < client_total; ++j){
                CWnd* client_obj = wndclient.Control(j);
                string client_name = client_obj.Name();
                if(client_name == prefix + "Button1"){
                    CButton* button = (CButton*) client_obj;
                    button.ColorBackground(clrNONE);
                    ChartRedraw();
                }
            }
            ChartRedraw();
        }
    }

    return (CDialog::OnDialogDragStart());
}

bool CLivePanelAndButton::OnDialogDragProcess(){
    string prefix=Name();
    int total=ControlsTotal();
    
    for(int i=0;i<total;i++){
        CWnd*obj=Control(i);
        string name=obj.Name();
        
        if(name==prefix+"Back"){
            CPanel *panel=(CPanel*) obj;
            color clr=(color)GETRGB(XRGB(rand()%255,rand()%255,rand()%255));
            panel.ColorBorder(clr);
            ChartRedraw();
        }
     }
   return(CDialog::OnDialogDragProcess());
}

//--- восстанавливаем цвет фона и рамки объектам "Border", "Back" или "Client"
bool CLivePanelAndButton::OnDialogDragEnd(){
    string prefix = Name();
    // int total = ExtDialog.ControlsTotal();
    int total = ControlsTotal();

    for(int i = 0; i < total; ++i){
        // CWnd* obj = ExtDialog.Control(i);
        CWnd* obj = Control(i);

        string name = obj.Name();

        if(name == prefix + "Border"){
            CPanel* panel = (CPanel*) obj;
            panel.ColorBackground(CONTROLS_DIALOG_COLOR_BG);
            panel.ColorBorder(CONTROLS_DIALOG_COLOR_BORDER_LIGHT);
            ChartRedraw();
        }
        if(name == prefix + "Back"){
            CPanel* panel = (CPanel*) obj;
            panel.ColorBackground(CONTROLS_DIALOG_COLOR_BG);
            color border = (m_panel_flag) ? CONTROLS_DIALOG_COLOR_BG : CONTROLS_DIALOG_COLOR_BORDER_DARK;
            panel.ColorBorder(border);
            ChartRedraw();
        }
        if(name == prefix + "Client"){
            CWndClient* wndclient = (CWndClient*) obj;
            wndclient.ColorBackground(CONTROLS_DIALOG_COLOR_CLIENT_BG);
            wndclient.ColorBorder(CONTROLS_DIALOG_COLOR_CLIENT_BORDER);

            int client_total = wndclient.ControlsTotal();
            for(int j = 0; j < client_total; ++j){
                CWnd* client = wndclient.Control(j);
                if(client.Name() == prefix + "Button1"){
                    CButton* button = (CButton*) client;
                    button.ColorBackground(CONTROLS_BUTTON_COLOR_BG);
                    ChartRedraw();
                }
            }
            ChartRedraw();
        }
    }
    return (CDialog::OnDialogDragEnd());
}

bool CLivePanelAndButton::CreateButton1(){
    int x1 = INDENT_LEFT;
    int y1 = INDENT_TOP;
    int x2 = x1 + BUTTON_WIDTH;
    int y2 = y1 + BUTTON_HEIGHT;

    string prefix = Name();
    if(!m_button1.Create(0, prefix + "Button1", 0, x1, y1, x2, y2)){
        return (false);
    }
    if(!m_button1.Text("Client color")){
        return (false);
    }
    if(!Add(m_button1)){
        return (false);
    }

    return (true);
}

bool CLivePanelAndButton::CreateButton2(){
    int x1 = INDENT_LEFT + BUTTON_WIDTH + CONTROLS_GAP_X;
    int y1 = INDENT_TOP;
    int x2 = x1 + BUTTON_WIDTH;
    int y2 = y1 + BUTTON_HEIGHT;

    string prefix = Name();
    if(!m_button2.Create(0, prefix + "Button2", 0, x1, y1, x2, y2)){
        return (false);
    }
    if(!m_button2.Text("Caption color")){
        return (false);
    }
    if(!Add(m_button2)){
        return (false);
    }

    return (true);
}

void CLivePanelAndButton::OnClickButton1(){
    string prefix = Name();
    int total = ControlsTotal();

    for(int i = 0; i < total; ++i){
        CWnd* obj = Control(i);
        string name = obj.Name();

        if(name == prefix + "Client"){
            CWndClient* wndclient = (CWndClient*) obj;
            color clr = (color)GETRGB(XRGB(rand()%255, rand()%255, rand()%255));
            wndclient.ColorBackground(clr);
            ChartRedraw();
            return;
        }
    }
}

void CLivePanelAndButton::OnClickButton2(){
    string prefix = Name();
    int total = ControlsTotal();

    for(int i = 0; i < total; ++i){
        CWnd* obj = Control(i);
        string name = obj.Name();

        if(name == prefix + "Caption"){
            CEdit* edit = (CEdit*) obj;
            color clr = (color)GETRGB(XRGB(rand()%255, rand()%255, rand()%255));
            edit.ColorBackground(clr);
            ChartRedraw();
            return;
        }
    }
}

EVENT_MAP_BEGIN(CLivePanelAndButton)
    ON_EVENT(ON_CLICK, m_button1, OnClickButton1)
    ON_EVENT(ON_CLICK, m_button2, OnClickButton2)
EVENT_MAP_END(CAppDialog)