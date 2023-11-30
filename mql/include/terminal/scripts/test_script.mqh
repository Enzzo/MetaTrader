#include <trade/AccountInfo.mqh>

#include <trade/mm.mqh>
// #include <trade/Trade.mqh>

class TestScript{
public:
    TestScript(){
        // _trade.SetExpertMagicNumber(123);
    };
    
    void run(){
        Print("Test script");
    }

private:
    mm      _mm;
    CObject* _object;
    // CTrade  _trade;
};