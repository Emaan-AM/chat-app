// src/App.test.js
import { render, screen } from '@testing-library/react';
import App from './App';

// Make sure environment variables exist
describe('Environment configuration', () => {
  test('loads environment variables from .env', () => {
    expect(process.env.REACT_APP_BACKEND_SERVICE_URL).toBeDefined();
    expect(process.env.REACT_APP_WEBSOCKET_SERVICE_URL).toBeDefined();
  });
});

// Basic render test
test('renders chat app main component', () => {
  render(<App />);
  const appElement = screen.getByTestId('app-root'); // we'll add this ID in App.js
  expect(appElement).toBeInTheDocument();
});
