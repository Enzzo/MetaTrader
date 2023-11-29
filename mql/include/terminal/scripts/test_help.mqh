class TestHelp{
public:
    TestHelp(){}
    
    void run(){        
        Print(SYMBOL_CALC_MODE_FOREX);        
        Print(SYMBOL_CALC_MODE_FUTURES);
        Print(SYMBOL_CALC_MODE_CFD);
        Print(SYMBOL_CALC_MODE_CFDINDEX);
        Print(SYMBOL_CALC_MODE_CFDLEVERAGE);
        Print(SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE);
        Print(SYMBOL_CALC_MODE_EXCH_STOCKS);
        Print(SYMBOL_CALC_MODE_EXCH_FUTURES);
        Print(SYMBOL_CALC_MODE_EXCH_FUTURES_FORTS);
        Print(SYMBOL_CALC_MODE_EXCH_BONDS);
        Print(SYMBOL_CALC_MODE_EXCH_STOCKS_MOEX);
        Print(SYMBOL_CALC_MODE_EXCH_BONDS_MOEX);
        Print(SYMBOL_CALC_MODE_SERV_COLLATERAL);
    }
};