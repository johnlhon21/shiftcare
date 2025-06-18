# ShiftCare - Client Datasets Scanner – Ruby Command-Line App

A command-line Ruby application to work with client data in JSON format. This tool enables users to:

* Search for clients by partial name and email
* Detect duplicate emails

---

## Features

* **Search by Name**
  Search is case-insensitive and supports partial matches.
* **Search by Email**
  Search is case-insensitive and supports partial matches.
* **Detect Duplicate Emails**
  Finds clients sharing the same email address.
* **Custom JSON path input**
  Can provide a different JSON file as datasets

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

### 3. Make the client executable

```bash
chmod +x bin/client
```

### 4. Run the CLI

```bash
bin/client help
```

---

## Usage Examples

### Search by name

```bash
bin/client search --query "john"
```

### Search by dynamic column ex. ```email```

```bash
bin/client search --query "john" --column "email"
```

### Provide a custom JSON file

```bash
bin/client search --query "john" --file "path/to/json_file"
```

### Find duplicate emails

```bash
bin/client duplicates
```

---

## Running Tests

```bash
bundle exec rspec
```
# To show the test case scenarios
```
bundle exec rspec -f d
```

Includes test coverage for:

* Matching and non-matching queries
* Duplicate and unique emails
* Invalid or Unsupported arguments
* Empty and malformed data
* The provided file are invalid or not found

## Assumptions & Decisions

* The dataset is a JSON array of objects, each with at least `id`,`full_name` and `email`.
* If the file is not provided, the application scans the default JSON file `data/clients.json` as the default dataset.
* Search only targets the `full_name` field by default.
* You can pass `--column` argument to dynamically define the column to search from the dataset.

---

## Limitations & Improvements

* Datasets are loaded every time the command is run
* Define a driver in the loader to support different sources of datasets, not just from a JSON file. (ex. third-party api, database)

---

## Future Enhancements

If given more time, the following could be added:

* **Storing of json datasets to a Cache** (Redis or built in ruby cache)

* **Support different sources for datasets** (database or third-party api)
  
* **REST API layer** (e.g., Rails API)
  ```
  GET /search?column=full_name&q=john
  ```
  
* **Scalable performance** (database-backed or caching)

---

## Author

**Marlon Bagayawa**
GitHub: [marlon-paymongo](https://github.com/johnlhon21)

---

## 📄 License

This project is licensed under the MIT License.
