# ShiftCar - Client Datasets Scanner – Ruby Command-Line App

A command-line Ruby application to work with client data in JSON format. This tool enables users to:

* Search for clients by partial name and email
* Detect duplicate emails

---

## 📦 Features

* **Search by Name**
  Search is case-insensitive and supports partial matches.
* **Search by Email**
  Search is case-insensitive and supports partial matches.
* **Detect Duplicate Emails**
  Finds clients sharing the same email address.
**Custom JSON path input**
  Can provide a different json file as datasets

---

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/shiftcare.git
cd shiftcare
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Run the CLI tool

```bash
bin/client help
```

---

## 🛠️ Usage Examples

### 🔍 Search by name

```bash
bin/client search --query "john"
```

### 🔍 Search by dynamic column ex. "email"

```bash
bin/client search --query "john" --column "email"
```

### 📧 Find duplicate emails

```bash
bin/client_tool duplicates
```

---

## 🤪 Running Tests

```bash
bundle exec rspec
```

Includes test coverage for:

* Matching and non-matching queries
* Duplicate and unique emails
* Invalid arguments
* Empty and malformed data
* Provider file are invalid or not found

## Assumptions & Decisions

* The dataset is a JSON array of objects, each with at least `id`,`full_name` and `email`.
* Search only targets the `full_name` field by default.
* You can pass `--column` argument to dynamically define the column to search from dataset.

---

## imitations & Improvements

* Dataset are loaded everytime it runs the command

---

## Future Enhancements

If given more time, the following could be added:

* **Storing of json datasets to a Cache** (Redis or built in ruby cache)

* **REST API layer** (e.g., Rails API)
  ```
  GET /search?field=full_name&q=john
  ```
  
* **Scalable performance** (database-backed or cache)

---

## Author

**Marlon Bagayawa**
GitHub: [marlon-paymongo](https://github.com/johnlhon21)

---

## 📄 License

This project is licensed under the MIT License.
