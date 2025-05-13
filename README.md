# 🚗 Driver Reputation Passport (DRP)

A decentralized driver record system built on Ethereum, providing a tamper-proof and transparent profile for drivers, their vehicles, and accident history.

## ✨ Overview

The **Driver Reputation Passport** smart contract enables authorities or organizations to:

- Add and manage verified driver profiles with a unique 6-digit ID
- Attach vehicle information to a driver
- Record accident histories
- Maintain admin-controlled access for secure and authorized data entry

## 🔐 Access Control

- **Owner:** The contract deployer; has exclusive rights to add or remove admins.
- **Admins:** Authorized personnel who can add driver, vehicle, and accident data.

## 🧱 Key Features

- Unique 6-digit driver IDs starting from `100000`
- Structured data for:
  - Driver personal and license information
  - Vehicle registration, insurance, and PUC data
  - Accident records with photos, FIR details, and claim status
- Publicly accessible read-only functions
- Emits events for all major actions for easy tracking

## 📦 Data Structures

- `DriverInfo`: Name, DOB, contact, license, blood group, and image
- `VehicleInfo`: Registration, PUC, insurance, ownership
- `AccidentInfo`: Date, location, cause, case/claim status, FIR

## 📜 Functions

| Function | Description |
|---------|-------------|
| `addDriver(...)` | Adds a new driver (admin only) |
| `addVehicle(...)` | Associates a vehicle to a driver (admin only) |
| `addAccident(...)` | Logs an accident for a driver (admin only) |
| `getDriverData(driverId)` | Fetches all details for a driver |
| `getDriverInfo(driverId)` | Fetches basic driver info |
| `getVehicleInfo(driverId)` | Fetches vehicle info |
| `getAccidentHistory(driverId)` | Lists all recorded accidents |
| `driverExists(driverId)` | Checks if driver exists |
| `addAdmin(address)` | Adds a new admin (owner only) |
| `removeAdmin(address)` | Removes an admin (owner only) |

## ⚙️ Deployment

This contract is written in **Solidity 0.8.0** and compatible with tools like:

- [Remix IDE](https://remix.ethereum.org/)
- Ganache local blockchain for testing

> Built for secure and transparent driver data management in a decentralized world. 🌐
