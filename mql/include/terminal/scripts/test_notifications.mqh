class TestNotifications{
public:
    void OnStart(){

        string error = "";
        ResetLastError();
        if(!SendNotification("Hello")){
            error += IntegerToString(GetLastError());
        }

        ResetLastError();
        if(!SendNotification("Привет")){
            if(StringLen(error) > 0){
                error += " ";
            }
            error += IntegerToString(GetLastError());
        }

        if(StringLen(error) > 0){
            Print(error);
        }
    }
};