# 🚌 Bus Booking Management System (TBMS)

A terminal-based **Bus Booking Management System** built entirely in **Shell Script (POSIX sh)**. It provides a full-featured, menu-driven interface to manage buses, bookings, payments, and cancellations — all stored in plain text files with no external database required.

---

## 📁 Project Structure

```
tbms/
├── tbms.sh            # Main entry point — launches the system
├── bus.sh             # Bus management module
├── booking.sh         # Booking & ticket management module
├── payment.sh         # Payment management module
├── cancellation.sh    # Cancellation management module
├── bus.txt            # Auto-generated: bus records (created at runtime)
├── booking.txt        # Auto-generated: booking records (created at runtime)
├── payment.txt        # Auto-generated: payment records (created at runtime)
└── cancellation.txt   # Auto-generated: cancellation records (created at runtime)
```

> **Note:** All `.txt` files are auto-created at runtime. You don't need to create them manually.

---

## ✨ Features

### 🚍 Bus Management (`bus.sh`)
- Add new buses with full details (name, number, route, timings, category, price, seats)
- View all available buses in a formatted table
- Search buses by source and destination city
- Delete a bus record by bus number
- Duplicate bus number validation

### 🎟️ Booking Management (`booking.sh`)
- Create new bookings with live seat availability check
- Automatically deducts booked seats from available count
- View all bookings in a formatted list
- Delete a booking and restore seats to the bus
- Search a booking by Booking ID
- View formatted ticket with individual seat/ticket numbers

### 💳 Payment Management (`payment.sh`)
- Make payment for a booking (UPI / Card / Cash)
- Displays booking summary before confirming payment
- Prevents duplicate payments for the same booking
- View all payment records

### ❌ Cancellation Management (`cancellation.sh`)
- Cancel an existing booking by Booking ID
- Automatically restores seats to the bus
- Removes associated payment record on cancellation
- View all cancellation records with reason and status

---

## 🚀 Getting Started

### Prerequisites

- A Unix/Linux/macOS system **or** Git Bash / WSL on Windows
- `sh` (POSIX shell) — available by default on all Unix systems

### Installation

```bash
# Clone the repository
git clone https://github.com/your-username/bus-booking-management-system.git

# Navigate to the project directory
cd bus-booking-management-system

# Make all scripts executable
chmod +x *.sh
```

### Run the Application

```bash
sh tbms.sh
```

---

## 🖥️ Usage

When you run `tbms.sh`, you'll see the main menu:

```
======================================================
        BUS BOOKING MANAGEMENT SYSTEM
======================================================
1. Buses
2. Bookings (with Tickets)
3. Payments
4. Cancellations
5. Exit
------------------------------------------------------
Please enter your choice:
```

Navigate using number keys. Each module has its own submenu.

### Typical Workflow

1. **Add a Bus** → Go to `Buses → Add New Bus`
2. **Create a Booking** → Go to `Bookings → Create New Booking` (select route, bus, category, seats)
3. **Make Payment** → Go to `Payments → Make Payment` (enter Booking ID)
4. **View Ticket** → Go to `Bookings → View Ticket` (enter Booking ID)
5. **Cancel if needed** → Go to `Cancellations → Cancel Booking`

---

## 📋 Data Format

All data is stored in pipe-delimited (`|`) plain text files.

| File | Format |
|------|--------|
| `bus.txt` | `Name\|BusNo\|Source\|Dest\|DepTime\|ArrTime\|Category\|Price\|TotalSeats\|AvailSeats` |
| `booking.txt` | `BookingID\|Name\|Phone\|BusNo\|Category\|Seats\|TotalAmount` |
| `payment.txt` | `PaymentID\|BookingID\|Amount\|Method\|Status` |
| `cancellation.txt` | `CancelID\|BookingID\|Reason\|Status` |

---

## 🔒 Validations & Business Rules

- **No duplicate IDs** — Booking ID, Bus Number, Payment ID, and Cancellation ID are all checked for uniqueness
- **Seat availability** — Cannot book more seats than available
- **One payment per booking** — Duplicate payments are blocked
- **Cascade on cancel** — Cancelling a booking restores seats AND removes the payment record
- **Case-insensitive matching** — City names and categories are matched regardless of case

---

## 🛠️ Tech Stack

| Component | Technology |
|-----------|------------|
| Language | POSIX Shell Script (`sh`) |
| Data Storage | Plain text files (pipe-delimited) |
| Text Processing | `awk`, `grep`, `cut`, `sed` |
| Platform | Linux / macOS / WSL / Git Bash |

---

## 📸 Sample Output

**View Ticket:**
```
======================================================
                   TICKET DETAILS
======================================================
Booking ID : BKG-1
Name       : Rahul Kumar
Phone      : 9876543210
Bus No     : BUS-101
Category   : AC
Seats      : 2
Amount     : ₹1200
------------------------------------------------------
Ticket No : TKT-BKG-1-1 | Seat-1
Ticket No : TKT-BKG-1-2 | Seat-2
======================================================
```

---

## 🤝 Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request for:
- Bug fixes
- New features (e.g., date-based filtering, admin login)
- Code improvements or refactoring

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).

---

## 👨‍💻 Author

Built with ❤️ using Shell Scripting.  
Feel free to star ⭐ the repo if you found it useful!
