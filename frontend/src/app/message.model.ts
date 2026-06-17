export interface Message {
  from: string;
  content: string;
  timestamp: string; // ou Date, mais string correspond bien à votre Java
}
