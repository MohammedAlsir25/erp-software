# ERP Software

A modern, scalable ERP (Enterprise Resource Planning) software application designed to streamline business operations including inventory management, sales, customer management, employee tracking, and transactions.

---

## Features

- **Customer Management:** Manage customer data efficiently.
- **Product & Inventory Management:** Track products and inventory levels.
- **Sales & Transactions:** Record sales and financial transactions.
- **Employee Management:** Maintain employee records and roles.
- **Modular Architecture:** Organized codebase with separate modules for scalability.
- **Testing:** Includes unit and integration tests for core functionalities.

---

## Technology Stack

- **Language:** Dart
- **Framework:** Flutter (assumed from Dart usage)
- **Database:** SQLite (assumed from database_helper.dart)
- **Testing:** Dart test framework

---

## Getting Started

### Prerequisites

- Dart SDK installed
- Flutter SDK installed (if applicable)
- Git installed

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/MohammedAlsir25/erp-software.git
   cd erp-software
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the application:

   ```bash
   flutter run
   ```

---

## Project Structure

- `lib/models/` - Data models for customers, products, sales, transactions, employees, and users.
- `lib/database/` - Database helper for SQLite operations.
- `lib/inventory_module.dart` - Inventory management module.
- `lib/main.dart` - Application entry point.
- `test/` - Unit and integration tests.

---

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

---

## License

This project is licensed under the MIT License.

---

## Contact

For questions or support, please open an issue or contact the maintainer.
