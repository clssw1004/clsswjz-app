# clsswjz -- Personal Finance App

A cross-platform finance management application built with Flutter, supporting multiple account books, collaboration, and fund account management.

## Features

### Transaction Management
- Income/Expense recording
- Custom category management
- Merchant management
- Fund account management
- Multiple account books
- Transaction filtering and search

### Account Book Management
- Create and manage multiple account books
- Member permission management
- Book sharing and collaboration
- Default book setting

### User System
- User registration and login
- Profile management
- Invitation code system
- Backend service configuration

## Pages Description

### Login Page (LoginPage)
- User login entry
- Username/password authentication
- Registration link
- Backend service configuration access

### Registration Page (RegisterPage)
- New user registration
- Email verification
- Basic information setup

### Home Page (HomePage)
- Transaction list display
- Quick transaction entry
- Statistics overview
- Bottom navigation bar

### Transaction Pages
- Transaction List (AccountItemList)
  - Date-based grouping
  - Income/Expense statistics
  - Filter functionality
  
- Transaction Form (AccountItemForm)
  - Amount input
  - Category selection
  - Date/time selection
  - Account selection
  - Notes (optional)

### Settings Page (SettingsPage)
- Account Book Management
  - Category management
  - Merchant management
  - Account management
- Theme Settings
  - Light/Dark mode
  - Theme color selection
- System Settings
  - Backend service configuration
  - Developer options

### User Profile Page (UserInfoPage)
- Profile display and editing
- Invitation code management
- Logout functionality

## Usage Guide

### First Time Setup
1. Open the app to the login page
2. Configure backend service if needed via "Backend Service Settings"
3. New users click "Register Now" to create an account
4. After login, create or join an account book

### Recording Transactions
1. Click "+" on home page to create new transaction
2. Select income/expense type
3. Enter amount
4. Choose category
5. Select account
6. Add notes (optional)
7. Save transaction

### Account Book Management
1. Access book management from settings
2. Create new or manage existing books
3. Configure member permissions
4. Manage categories and accounts

### Theme Customization
1. Access theme settings
2. Choose light/dark mode
3. Select theme color

## Technical Features
- Material Design 3 compliance
- Multi-platform support (Android, iOS, Web, Desktop)
- Responsive layout for various screen sizes
- Dark mode support
- Local data caching
- Real-time data synchronization

## Development Notes
- Built with Flutter framework
- Provider state management
- Customizable backend service
- Clean Architecture implementation
- Unified error handling
- Comprehensive theme support

## API Integration

### Server Health Check
