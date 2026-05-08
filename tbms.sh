#!/bin/sh

while true
do
echo "======================================================"
echo "        BUS BOOKING MANAGEMENT SYSTEM"
echo "======================================================"
echo "1. Buses"
echo "2. Bookings (with Tickets)"
echo "3. Payments"
echo "4. Cancellations"
echo "5. Exit"
echo "------------------------------------------------------"

printf "Please enter your choice: "
read ch

case $ch in

1)
echo "Opening Bus Management Module..."
sh bus.sh
;;

2)
echo "Opening Booking & Ticket Module..."
sh booking.sh
;;

3)
echo "Opening Payment Module..."
sh payment.sh
;;

4)
echo "Opening Cancellation Module..."
sh cancellation.sh
;;

5)
echo "======================================================"
echo "Thank you for using the Bus Booking Management System."
echo "Session has been closed successfully."
echo "======================================================"
exit
;;

*)
echo "Invalid choice. Please try again."
;;

esac
done

