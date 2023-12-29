import { BadGatewayException } from '@nestjs/common';
import axios, { AxiosInstance } from 'axios';

type KeycloakTokenResponse = {
  access_token: string;
  expires_in: number;
  refresh_expires_in: number;
  token_type: string;
  'not-before-policy': number;
  scope: string;
  Id_token: string;
};

export class SSOClient {
  private readonly client: AxiosInstance;

  constructor() {
    this.client = axios.create({
      baseURL: 'https://accounts.seguros.vitta.com.br',
    });
  }

  async getAccessToken(): Promise<KeycloakTokenResponse> {
    const formData = new URLSearchParams();
    const email = 'example@email.com';
    const emailInBase64 = Buffer.from(email, 'utf-8').toString('base64');

    formData.append('grant_type', 'client_credentials');
    formData.append('client_id', 'customers');
    formData.append('client_secret', '453000f7-47a0-4489-bc47-891c742650e2');
    formData.append('username', email);
    formData.append('password', emailInBase64);
    formData.append('scope', 'openid');
    try {
      const { data } = await this.client.post(
        '/auth/realms/careers/protocol/openid-connect/token',
        formData,
      );
      return data as unknown as KeycloakTokenResponse;
    } catch (error) {
      throw new BadGatewayException('SSO is not available');
    }
  }
}
