// #include <trade/account_info.mqh>
#include <trade/symbol_info.mqh>

#include <trade/mm.mqh>
// #include <trade/Trade.mqh>

class TestScript{
public:
    TestScript(){
        _smb = new CSymbolInfo();
        _smb.Name(Symbol());
        // _trade.SetExpertMagicNumber(123);
    };
    
    ~TestScript(){
        if(CheckPointer(_smb) == POINTER_DYNAMIC){
            Print(_smb.Name()+" delete");
            delete(_smb);
        }
    }
    void run(){
        Print("Test script");
    }

private:
    mm      _mm;
    CSymbolInfo* _smb;
    CObject* _object;
    // CTrade  _trade;
};