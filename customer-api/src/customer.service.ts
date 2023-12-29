import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { CreateCustomerDto } from './dto/createCustomerDto';
import { Customer } from './domain/customer';
import { v4 as uuidv4 } from 'uuid';
import { SSOClient } from './clients/sso.client';
import RedisClient from './clients/redis.client';
import { UpdateCustomerDto } from './dto/updateCustomerDto';

@Injectable()
export class CustomerService {
  async createCustomer(
    createCustomerDto: CreateCustomerDto,
  ): Promise<Customer> {
    const { access_token } = await new SSOClient().getAccessToken();
    if (!access_token) throw new UnauthorizedException('Unauthorized');

    const customer: Customer = {
      id: uuidv4(),
      name: createCustomerDto.name,
      document: createCustomerDto.document,
    };

    const redis = await RedisClient.getRedisConnection();
    const jsonString = JSON.stringify(customer);
    await redis.set(`customer:${customer.id}`, jsonString);
    return customer;
  }

  async getCustomerById(id: string): Promise<Customer> {
    const { access_token } = await new SSOClient().getAccessToken();
    if (!access_token) throw new UnauthorizedException('Unauthorized');

    const redis = await RedisClient.getRedisConnection();
    const key = `customer:${id}`;
    const customer = await redis.get(key);
    if (customer) {
      return JSON.parse(customer);
    }
    throw new NotFoundException('Customer not found');
  }

  async updateCustomerById(
    id: string,
    updateCustomerDto: UpdateCustomerDto,
  ): Promise<Customer> {
    if (
      !updateCustomerDto.name &&
      !updateCustomerDto.document &&
      !updateCustomerDto.id
    )
      throw new BadRequestException('No data to update');
    if (updateCustomerDto.id) {
      const uuidRegex =
        /^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$/;
      if (!uuidRegex.test(updateCustomerDto.id)) {
        throw new BadRequestException('new id is not a uuid string');
      }
    }

    const { access_token } = await new SSOClient().getAccessToken();
    if (!access_token) throw new UnauthorizedException('Unauthorized');

    const redis = await RedisClient.getRedisConnection();

    if (updateCustomerDto.id) {
      const idAlreadyExists = await redis.exists(
        `customer:${updateCustomerDto.id}`,
      );
      if (idAlreadyExists)
        throw new ConflictException('Id already exists on the database');
    }

    const key = `customer:${id}`;
    const customerStr = await redis.get(key);
    const customer: Customer = JSON.parse(customerStr);
    if (customer) {
      const newCustomerData: Customer = {
        id: updateCustomerDto.id || customer.id,
        name: updateCustomerDto.name || customer.name,
        document: updateCustomerDto.document || customer.document,
      };

      const key = updateCustomerDto.id
        ? `customer:${updateCustomerDto.id}`
        : `customer:${id}`;
      await redis.set(key, JSON.stringify(newCustomerData));

      if (updateCustomerDto.id) {
        await redis.del(`customer:${id}`);
      }
      return newCustomerData;
    }
    throw new NotFoundException('Customer not found');
  }
}
