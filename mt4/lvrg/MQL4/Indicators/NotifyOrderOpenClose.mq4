#property indicator_chart_window

extern bool SendEmailNotifications = true;
extern bool SendPushNotifications = false;
extern bool SendOpenOrders = true;
extern bool SendCloseOrders = true;
extern bool IncludeCustomMessageBelow = true;
extern string AdditionalCustomMessage = "MA strategy";


datetime dt;
int oldtemp;
int oldhist;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   dt = Time[0];
   oldtemp = 0;
   oldhist = OrdersHistoryTotal();
   Comment("\nNotification Indicator v.1\nby Dworf"); 
  }
  
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
 
 
    /////////////////////////////////
   //for opened and pending orders//
   ///////////////////////////////// 
  
   if (oldtemp < OrdersTotal() && SendOpenOrders == true)
   {
      string message;
      string messagecustom;
   
      OrderSelect(OrdersTotal()-1, SELECT_BY_POS);
   
     //BUY
      if(OrderType()==OP_BUY && OrderCloseTime()==0) {
      message="OPEN BUY: "+OrderSymbol()+" ticket:"+OrderTicket()+" size:"+DoubleToStr(OrderLots(),2)+" price:"+DoubleToStr(OrderOpenPrice(),5)+" equity:"+DoubleToStr(AccountEquity(),2);
      messagecustom="OPEN BUY: "+OrderSymbol()+" ("+AdditionalCustomMessage+") ticket:"+OrderTicket()+" size:"+DoubleToStr(OrderLots(),2)+" price:"+DoubleToStr(OrderOpenPrice(),5)+" equity:"+DoubleToStr(AccountEquity(),2);
         if (SendPushNotifications) {
            if (IncludeCustomMessageBelow) {
               SendNotification(messagecustom);
            } else {
               SendNotification(message);
            }
         }
         if (SendEmailNotifications) {
            if (IncludeCustomMessageBelow) {
               SendMail("OPEN BUY: "+OrderSymbol()+" ("+AdditionalCustomMessage+")", messagecustom);
            } else {
               SendMail("OPEN BUY: "+OrderSymbol()+"", message);
            }
         }
      }
   
     //SELL
      if(OrderType()==OP_SELL && OrderCloseTime()==0) {
      message="OPEN SELL: "+OrderSymbol()+" ticket:"+OrderTicket()+" size:"+DoubleToStr(OrderLots(),2)+" price:"+DoubleToStr(OrderOpenPrice(),5)+" equity:"+DoubleToStr(AccountEquity(),2);
      messagecustom="OPEN SELL: "+OrderSymbol()+" ("+AdditionalCustomMessage+") ticket:"+OrderTicket()+" size:"+DoubleToStr(OrderLots(),2)+" price:"+DoubleToStr(OrderOpenPrice(),5)+" equity:"+DoubleToStr(AccountEquity(),2);
         if (SendPushNotifications) {
            if (IncludeCustomMessageBelow) {
               SendNotification(messagecustom);
            } else {
               SendNotification(message);
            }
         }
         if (SendEmailNotifications) {
            if (IncludeCustomMessageBelow) {
               SendMail("OPEN SELL: "+OrderSymbol()+" ("+AdditionalCustomMessage+")", messagecustom);
            } else {
               SendMail("OPEN SELL: "+OrderSymbol()+"", message);
            }         }
      }
        
   }
      oldtemp = OrdersTotal();
  
  
   ////////////////////////////////
   //for closed or canceled orders//
   ////////////////////////////////

   if (oldhist < OrdersHistoryTotal() && SendCloseOrders == true)
   {
      OrderSelect(OrdersHistoryTotal()-1, SELECT_BY_POS,MODE_HISTORY);
	  
	  //BUY CLOSE
      if(OrderType()==OP_BUY && OrderCloseTime()>0) {
      message="CLOSE BUY: "+OrderSymbol()+" ticket:"+OrderTicket()+" size:"+DoubleToStr(OrderLots(),2)+" close:"+DoubleToStr(OrderClosePrice(),5)+" profit:"+DoubleToStr(OrderProfit(),2)+" equity:"+DoubleToStr(AccountEquity(),2);
      messagecustom="CLOSE BUY: "+OrderSymbol()+" ("+AdditionalCustomMessage+") ticket:"+OrderTicket()+" size:"+DoubleToStr(OrderLots(),2)+" close:"+DoubleToStr(OrderClosePrice(),5)+" profit:"+DoubleToStr(OrderProfit(),2)+" equity:"+DoubleToStr(AccountEquity(),2);
         if (SendPushNotifications) {
            if (IncludeCustomMessageBelow) {
               SendNotification(messagecustom);
            } else {
               SendNotification(message);
            }
         }
         if (SendEmailNotifications) {
            if (IncludeCustomMessageBelow) {
               SendMail("CLOSE BUY: "+OrderSymbol()+" ("+AdditionalCustomMessage+")", messagecustom);
            } else {
               SendMail("CLOSE BUY: "+OrderSymbol()+"", message);
            }
         }
      }
		
	  //SELL CLOSE	
      if(OrderType()==OP_SELL && OrderCloseTime()>0) {
      message="CLOSE SELL: "+OrderSymbol()+" ticket:"+OrderTicket()+" size:"+DoubleToStr(OrderLots(),2)+" close:"+DoubleToStr(OrderClosePrice(),5)+" profit:"+DoubleToStr(OrderProfit(),2)+" equity:"+DoubleToStr(AccountEquity(),2);
      messagecustom="CLOSE SELL: "+OrderSymbol()+" ("+AdditionalCustomMessage+") ticket:"+OrderTicket()+" size:"+DoubleToStr(OrderLots(),2)+" close:"+DoubleToStr(OrderClosePrice(),5)+" profit:"+DoubleToStr(OrderProfit(),2)+" equity:"+DoubleToStr(AccountEquity(),2);
         if (SendPushNotifications) {
            if (IncludeCustomMessageBelow) {
               SendNotification(messagecustom);
            } else {
               SendNotification(message);
            }
         }	  
         if (SendEmailNotifications) {
            if (IncludeCustomMessageBelow) {
               SendMail("CLOSE SELL: "+OrderSymbol()+" ("+AdditionalCustomMessage+")", messagecustom);
            } else {
               SendMail("CLOSE SELL: "+OrderSymbol()+"", message);
            }
         }
      }
   }
      oldhist = OrdersHistoryTotal();
 

   
//----
   return(0);
  }
//+------------------------------------------------------------------+