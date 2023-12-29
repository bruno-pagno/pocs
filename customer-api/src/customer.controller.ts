import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Put,
  ValidationPipe,
} from '@nestjs/common';
import { CustomerService } from './customer.service';
import { CreateCustomerDto } from './dto/createCustomerDto';
import { Customer } from './domain/customer';
import { UpdateCustomerDto } from './dto/updateCustomerDto';

@Controller('customer')
export class CustomerController {
  constructor(private readonly customerService: CustomerService) {}

  @Post()
  async createCustomer(
    @Body(new ValidationPipe()) createCustomerDto: CreateCustomerDto,
  ): Promise<Customer> {
    return this.customerService.createCustomer(createCustomerDto);
  }

  @Get(':id')
  async getCustomerById(@Param('id') id: string): Promise<Customer> {
    return this.customerService.getCustomerById(id);
  }

  @Put(':id')
  async updateCustomerById(
    @Param('id') id: string,
    @Body(new ValidationPipe()) updateCustomerDto: UpdateCustomerDto,
  ): Promise<Customer> {
    return this.customerService.updateCustomerById(id, updateCustomerDto);
  }
}
